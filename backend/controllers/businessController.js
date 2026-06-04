const pool = require('../db');


// GET ALL BUSINESSES
const getAllBusinesses = async (req, res) => {

    try {

        const result =
            await pool.query(
                'SELECT * FROM Business'
            );

        res.json(result.rows);

    } catch (err) {

        console.error(err);

        res.status(500).send('Server Error');

    }

};

module.exports = {
    getAllBusinesses
};