const pool = require('../db');

// ── GET ALL BUSINESSES (with city/state from location) ────────
const getAllBusinesses = async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT
                b.*,
                l.city,
                l.state,
                STRING_AGG(DISTINCT c.categoryname, ', ') AS categories
            FROM business b
            LEFT JOIN businesslocation bl ON b.businessid = bl.businessid
            LEFT JOIN location l          ON bl.locationid = l.locationid
            LEFT JOIN businesscategory bc ON b.businessid = bc.businessid
            LEFT JOIN category c          ON bc.categoryid = c.categoryid
            GROUP BY b.businessid, l.city, l.state
            ORDER BY b.businessid DESC
        `);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// ── GET BUSINESS LOOKUP (lightweight, for dropdowns) ──────────
const getBusinessLookup = async (req, res) => {
    try {
        const result = await pool.query(
            'SELECT businessid, name FROM business ORDER BY name ASC'
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// ── GET SINGLE BUSINESS BY ID ─────────────────────────────────
const getBusinessById = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query(
            'SELECT * FROM business WHERE businessid = $1', [id]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Business not found.' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// ── CREATE NEW BUSINESS ───────────────────────────────────────
const createBusiness = async (req, res) => {
    const { name, address, locationid, phone, website, subscription_tier, latitude, longitude, outdoor_dining, live_music, waterfront, pet_friendly, categoryIds } = req.body;

    let formattedWebsite = website ? website.trim() : null;
    if (formattedWebsite && !formattedWebsite.startsWith('http')) {
        formattedWebsite = 'https://' + formattedWebsite;
    }
    if (formattedWebsite && !/^https?:\/\//i.test(formattedWebsite)) {
        formattedWebsite = `https://${formattedWebsite}`;
    }

    if (!name || !address || !locationid || !categoryIds || categoryIds.length === 0) {
        return res.status(400).json({ error: "Storefront Name, Street Address, Region City, and Categories are all fully required." });
    }

    // Duplicate check — skipped if admin passes force:true
    const force = req.body.force === true || req.body.force === 'true';
    if (!force) {
        try {
            const dupCheck = await pool.query(`
                SELECT b.businessid, b.name, l.city, l.state
                FROM business b
                JOIN businesslocation bl ON b.businessid = bl.businessid
                JOIN location l ON bl.locationid = l.locationid
                WHERE LOWER(b.name) = LOWER($1) AND bl.locationid = $2
                LIMIT 1
            `, [name, locationid]);

            if (dupCheck.rows.length > 0) {
                const existing = dupCheck.rows[0];
                return res.status(409).json({
                    error: 'duplicate',
                    message: `A business named "${existing.name}" already exists in ${existing.city}, ${existing.state}.`,
                    existing
                });
            }
        } catch (dupErr) {
            console.error('Duplicate check error:', dupErr);
        }
    }

    const client = await pool.connect();
    try {
        await client.query('BEGIN');

        const businessResult = await client.query(`
            INSERT INTO business (name, address, phone, website, subscription_tier, latitude, longitude, outdoor_dining, live_music, waterfront, pet_friendly)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
            RETURNING businessid;
        `, [name, address, phone || null, formattedWebsite, subscription_tier || 'Basic',
            latitude || null, longitude || null,
            outdoor_dining || false, live_music || false,
            waterfront || false, pet_friendly || false]);

        const newBusinessId = businessResult.rows[0].businessid;

        await client.query(
            'INSERT INTO businesslocation (businessid, locationid) VALUES ($1, $2)',
            [newBusinessId, locationid]
        );

        for (const catId of categoryIds) {
            await client.query(
                'INSERT INTO businesscategory (businessid, categoryid) VALUES ($1, $2)',
                [newBusinessId, catId]
            );
        }

        await client.query('COMMIT');
        res.status(201).json({
            message: "Storefront business added successfully!",
            businessid: newBusinessId
        });
    } catch (err) {
        await client.query('ROLLBACK');
        console.error("Transaction Error inside createBusiness:", err);
        res.status(500).json({ error: "Server error writing business." });
    } finally {
        client.release();
    }
};

// ── UPDATE EXISTING BUSINESS ──────────────────────────────────
const updateBusiness = async (req, res) => {
    const { id } = req.params;
    const { name, address, phone, website, subscription_tier, is_verified, latitude, longitude, outdoor_dining, live_music, waterfront, pet_friendly, categoryIds } = req.body;

    let formattedWebsite = website ? website.trim() : null;
    if (formattedWebsite && !formattedWebsite.startsWith('http')) {
        formattedWebsite = 'https://' + formattedWebsite;
    }
    if (formattedWebsite && !/^https?:\/\//i.test(formattedWebsite)) {
        formattedWebsite = `https://${formattedWebsite}`;
    }

    const client = await pool.connect();
    try {
        await client.query('BEGIN');

        const updateResult = await client.query(`
            UPDATE business
            SET
                name              = COALESCE($1, name),
                address           = COALESCE($2, address),
                phone             = $3,
                website           = $4,
                subscription_tier = COALESCE($5, subscription_tier),
                is_verified       = COALESCE($6, is_verified),
                latitude          = $7,
                longitude         = $8,
                outdoor_dining    = COALESCE($9,  outdoor_dining),
                live_music        = COALESCE($10, live_music),
                waterfront        = COALESCE($11, waterfront),
                pet_friendly      = COALESCE($12, pet_friendly)
            WHERE businessid = $13
            RETURNING *;
        `, [name, address, phone || null, formattedWebsite, subscription_tier, is_verified,
            latitude || null, longitude || null,
            outdoor_dining, live_music, waterfront, pet_friendly, id]);

        if (updateResult.rows.length === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Business not found.' });
        }

        if (categoryIds && categoryIds.length > 0) {
            await client.query('DELETE FROM businesscategory WHERE businessid = $1', [id]);
            for (const catId of categoryIds) {
                await client.query(
                    'INSERT INTO businesscategory (businessid, categoryid) VALUES ($1, $2)',
                    [id, catId]
                );
            }
        }

        await client.query('COMMIT');
        res.json({ message: "Business updated successfully.", business: updateResult.rows[0] });
    } catch (err) {
        await client.query('ROLLBACK');
        console.error("Transaction Error inside updateBusiness:", err);
        res.status(500).json({ error: "Server error updating business." });
    } finally {
        client.release();
    }
};

// ── TOGGLE is_verified ────────────────────────────────────────
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
        res.json({
            message: `Business ${is_verified ? 'verified' : 'unverified'} successfully.`,
            business: result.rows[0]
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error updating verification status.' });
    }
};

// ── INCREMENT WEBSITE CLICK COUNT ─────────────────────────────
const incrementWebsiteClick = async (req, res) => {
    const { id } = req.params;
    const { device_id } = req.body;
    try {
        const result = await pool.query(
            'UPDATE business SET website_click_count = website_click_count + 1 WHERE businessid = $1 RETURNING businessid, name, website_click_count',
            [id]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Business not found.' });
        }
        // Log timestamped click for reporting (non-blocking)
        pool.query(
            'INSERT INTO business_click (businessid, click_type, device_id) VALUES ($1, $2, $3)',
            [id, 'website', device_id || null]
        ).catch(err => console.error('business_click insert error:', err));

        res.json({ success: true, website_click_count: result.rows[0].website_click_count });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error recording website click.' });
    }
};

// ── INCREMENT DIRECTIONS CLICK COUNT ─────────────────────────
const incrementDirectionsClick = async (req, res) => {
    const { id } = req.params;
    const { device_id } = req.body;
    try {
        const result = await pool.query(
            'UPDATE business SET directions_click_count = directions_click_count + 1 WHERE businessid = $1 RETURNING businessid, name, directions_click_count',
            [id]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Business not found.' });
        }
        // Log timestamped click for reporting (non-blocking)
        pool.query(
            'INSERT INTO business_click (businessid, click_type, device_id) VALUES ($1, $2, $3)',
            [id, 'directions', device_id || null]
        ).catch(err => console.error('business_click insert error:', err));

        res.json({ success: true, directions_click_count: result.rows[0].directions_click_count });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error recording directions click.' });
    }
};

// ── DELETE BUSINESS (cascades to deals, schedules, categories) ─
const deleteBusiness = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    if (isNaN(id)) return res.status(400).json({ error: 'Invalid business ID.' });

    const client = await pool.connect();
    try {
        await client.query('BEGIN');

        // Find all deals belonging to this business
        const dealResult = await client.query(
            'SELECT dealid FROM deal WHERE businessid = $1', [id]
        );
        const dealIds = dealResult.rows.map(r => r.dealid);

        // For each deal, remove its junction table entries first
        for (const dealId of dealIds) {
            await client.query('DELETE FROM dealcategory WHERE dealid = $1', [dealId]);
            await client.query('DELETE FROM dealschedule WHERE dealid = $1', [dealId]);
        }

        // Delete all deals for this business
        await client.query('DELETE FROM deal WHERE businessid = $1', [id]);

        // Remove business junction table entries
        await client.query('DELETE FROM businesscategory WHERE businessid = $1', [id]);
        await client.query('DELETE FROM businesslocation WHERE businessid = $1', [id]);

        // Finally delete the business itself
        const result = await client.query(
            'DELETE FROM business WHERE businessid = $1 RETURNING businessid, name',
            [id]
        );
        if (result.rows.length === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Business not found.' });
        }

        await client.query('COMMIT');
        res.json({
            message: `Business "${result.rows[0].name}" and ${dealIds.length} associated deal${dealIds.length !== 1 ? 's' : ''} deleted successfully.`,
            deals_deleted: dealIds.length
        });
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
    incrementWebsiteClick,
    incrementDirectionsClick,
    deleteBusiness
};