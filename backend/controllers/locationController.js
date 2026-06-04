const pool = require('../db');





// GET ALL LOCATIONS
const getAllLocations = async (req, res) => {

    try {

        const result = await pool.query(`
            SELECT
                LocationID,
                City,
                State
            FROM Location
            ORDER BY City
        `);

        res.json(result.rows);

    } catch (err) {

        console.error(err);

        res.status(500).send('Server Error');

    }

};





// GET ALL BUSINESSES BY LOCATION
const getBusinessesByLocation = async (req, res) => {

    try {

        const city = req.params.city;

        const result = await pool.query(`
            SELECT
                Business.Name,
                Business.Address,
                Business.Phone,
                Location.City
            FROM Business
            JOIN BusinessLocation
                ON Business.BusinessID =
                   BusinessLocation.BusinessID
            JOIN Location
                ON BusinessLocation.LocationID =
                   Location.LocationID
            WHERE Location.City = $1
        `, [city]);

        res.json(result.rows);

    } catch (err) {

        console.error(err);

        res.status(500).send('Server Error');

    }

};




module.exports = {
    getAllLocations,
    getBusinessesByLocation
};