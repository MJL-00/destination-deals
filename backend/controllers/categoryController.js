const pool = require('../db');


const getAllCategories = async (req, res) => {

    try {

        const result = await pool.query(`
            SELECT
                CategoryID,
                CategoryName
            FROM Category
            ORDER BY CategoryName
        `);

        res.json(result.rows);

    } catch (err) {

        console.error(err);

        res.status(500).send('Server Error');

    }

};





module.exports = {
    getAllCategories
};