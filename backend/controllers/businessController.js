const pool = require('../db');

// GET ALL BUSINESSES
const getAllBusinesses = async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM business');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// GET BUSINESS LOOKUP (lightweight, for dropdowns)
const getBusinessLookup = async (req, res) => {
    try {
        const result = await pool.query('SELECT businessid, name FROM business ORDER BY name ASC');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// GET SINGLE BUSINESS BY ID (for edit form)
const getBusinessById = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('SELECT * FROM business WHERE businessid = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Business not found.' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// CREATE NEW STOREFRONT PROFILE
const createBusiness = async (req, res) => {

    const { name, address, locationid, phone, website, subscription_tier, categoryIds } = req.body;

    let formattedWebsite = website ? website.trim() : null;
    if (formattedWebsite && !/^https?:\/\//i.test(formattedWebsite)) {
        formattedWebsite = `https://${formattedWebsite}`;
    }

    if (!name || !address || !locationid || !categoryIds || categoryIds.length === 0) {
        return res.status(400).json({ error: "Storefront Name, Street Address, Region City, and Categories are all fully required." });
    }

    const client = await pool.connect();

    try {
        await client.query('BEGIN');

        const businessQuery = `
            INSERT INTO business (name, address, phone, website, subscription_tier)
            VALUES ($1, $2, $3, $4, $5)
            RETURNING businessid;
        `;
        const businessResult = await client.query(businessQuery, [
            name,
            address,
            phone || null,
            formattedWebsite,
            subscription_tier || 'Basic'
        ]);
        const newBusinessId = businessResult.rows[0].businessid;

        const locationJunctionQuery = `
            INSERT INTO businesslocation (businessid, locationid) VALUES ($1, $2);
        `;
        await client.query(locationJunctionQuery, [newBusinessId, locationid]);

        const categoryJunctionQuery = `
            INSERT INTO businesscategory (businessid, categoryid) VALUES ($1, $2);
        `;
        for (const catId of categoryIds) {
            await client.query(categoryJunctionQuery, [newBusinessId, catId]);
        }

        await client.query('COMMIT');

        res.status(201).json({
            message: "Storefront business added successfully and linked to its local categories!",
            businessid: newBusinessId
        });

    } catch (err) {
        await client.query('ROLLBACK');
        console.error("Transaction Error inside createBusiness:", err);
        res.status(500).json({ error: "Server error writing localized business transaction details." });
    } finally {
        client.release();
    }
};

// UPDATE EXISTING BUSINESS
const updateBusiness = async (req, res) => {
    const { id } = req.params;
    const { name, address, phone, website, subscription_tier, is_verified, categoryIds } = req.body;

    let formattedWebsite = website ? website.trim() : null;
    if (formattedWebsite && !/^https?:\/\//i.test(formattedWebsite)) {
        formattedWebsite = `https://${formattedWebsite}`;
    }

    const client = await pool.connect();

    try {
        await client.query('BEGIN');

        const updateQuery = `
            UPDATE business
            SET
                name               = COALESCE($1, name),
                address            = COALESCE($2, address),
                phone              = $3,
                website            = $4,
                subscription_tier  = COALESCE($5, subscription_tier),
                is_verified        = COALESCE($6, is_verified)
            WHERE businessid = $7
            RETURNING *;
        `;
        const updateResult = await client.query(updateQuery, [
            name,
            address,
            phone || null,
            formattedWebsite,
            subscription_tier,
            is_verified,
            id
        ]);

        if (updateResult.rows.length === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Business not found.' });
        }

        // If categories were sent, replace them wholesale
        if (categoryIds && categoryIds.length > 0) {
            await client.query('DELETE FROM businesscategory WHERE businessid = $1', [id]);
            const catQuery = 'INSERT INTO businesscategory (businessid, categoryid) VALUES ($1, $2)';
            for (const catId of categoryIds) {
                await client.query(catQuery, [id, catId]);
            }
        }

        await client.query('COMMIT');

        res.json({
            message: "Business updated successfully.",
            business: updateResult.rows[0]
        });

    } catch (err) {
        await client.query('ROLLBACK');
        console.error("Transaction Error inside updateBusiness:", err);
        res.status(500).json({ error: "Server error updating business." });
    } finally {
        client.release();
    }
};

// TOGGLE is_verified FLAG
const verifyBusiness = async (req, res) => {
    const { id } = req.params;
    const { is_verified } = req.body;

    try {
        const result = await pool.query(
            'UPDATE business SET is_verified = $1 WHERE businessid = $2 RETURNING businessid, name, is_verified',
            [is_verified, id]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Business not found.' });
        }
        res.json({ message: `Business ${is_verified ? 'verified' : 'unverified'} successfully.`, business: result.rows[0] });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error updating verification status.' });
    }
};

// DELETE BUSINESS (and cascade junction rows)
const deleteBusiness = async (req, res) => {
    const { id } = req.params;
    const client = await pool.connect();

    try {
        await client.query('BEGIN');

        // Remove junction table entries first to avoid FK constraint errors
        await client.query('DELETE FROM businesscategory WHERE businessid = $1', [id]);
        await client.query('DELETE FROM businesslocation WHERE businessid = $1', [id]);

        const result = await client.query(
            'DELETE FROM business WHERE businessid = $1 RETURNING businessid, name',
            [id]
        );

        if (result.rows.length === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Business not found.' });
        }

        await client.query('COMMIT');
        res.json({ message: `Business "${result.rows[0].name}" deleted successfully.` });

    } catch (err) {
        await client.query('ROLLBACK');
        console.error("Transaction Error inside deleteBusiness:", err);
        res.status(500).json({ error: "Server error deleting business." });
    } finally {
        client.release();
    }
};

module.exports = {
    getAllBusinesses,
    getBusinessLookup,
    getBusinessById,
    createBusiness,
    updateBusiness,
    verifyBusiness,
    deleteBusiness
};