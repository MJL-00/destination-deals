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

// GET BUSINESS LOOKUP 
const getBusinessLookup = async (req, res) => {
    try {
        const result = await pool.query('SELECT businessid, name FROM business ORDER BY name ASC');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// CREATE NEW STOREFRONT PROFILE (Option A Architecture)
const createBusiness = async (req, res) => {
    
    const { name, address, locationid, phone, website, categoryIds } = req.body;
    
    // Clean up and standardize the Website URL format
    let formattedWebsite = website ? website.trim() : null;
    if (formattedWebsite && !/^https?:\/\//i.test(formattedWebsite)) {
        // If it doesn't start with http:// or https://, prepend https://
        formattedWebsite = `https://${formattedWebsite}`;
    }

    // Server-side parameter validation checking
    if (!name || !address || !locationid || !categoryIds || categoryIds.length === 0) {
        return res.status(400).json({ error: "Storefront Name, Street Address, Region City, and Categories are all fully required." });
    }

    const client = await pool.connect();

    try {
        await client.query('BEGIN'); // Start safe isolated transaction execution pipeline

        // Step 1: Write core branch row to the central business metadata layout table
        // FIXED: Kept column name as 'website' to match your actual database schema
        const businessQuery = `
            INSERT INTO business (name, address, phone, website)
            VALUES ($1, $2, $3, $4)
            RETURNING businessid;
        `;
        
        // FIXED: Passed 'formattedWebsite' into the $4 parameter spot instead of 'website'
        const businessResult = await client.query(businessQuery, [name, address, phone, formattedWebsite]);
        const newBusinessId = businessResult.rows[0].businessid;

        // Step 2: Directly assign the singular location pair to your businesslocation junction table
        const locationJunctionQuery = `
            INSERT INTO businesslocation (businessid, locationid)
            VALUES ($1, $2);
        `;
        await client.query(locationJunctionQuery, [newBusinessId, locationid]);

        // Step 3: Loop through your chosen tags array to populate the businesscategory junction entries
        const categoryJunctionQuery = `
            INSERT INTO businesscategory (businessid, categoryid)
            VALUES ($1, $2);
        `;
        for (const catId of categoryIds) {
            await client.query(categoryJunctionQuery, [newBusinessId, catId]);
        }

        await client.query('COMMIT'); // Persistently save state structures

        res.status(201).json({ 
            message: "Storefront business added successfully and linked to its local categories!", 
            businessid: newBusinessId 
        });

    } catch (err) {
        await client.query('ROLLBACK'); // Discard transaction steps if processing errors drop
        console.error("Transaction Error inside createBusiness:", err);
        res.status(500).json({ error: "Server error writing localized business transaction details." });
    } finally {
        client.release(); // Hand resource back to server cluster pool 
    }
};

module.exports = {
    getAllBusinesses,
    getBusinessLookup,
    createBusiness
};