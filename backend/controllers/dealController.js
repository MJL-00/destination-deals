const pool = require('../db');

// GET ALL DEALS____________________________________________________________________________________________________________
const getAllDeals = async (req, res) => {
    try {
        const result = await pool.query(
            'SELECT * FROM Deal'
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// GET DEALS BY DAY
const getDealsByDay = async (req, res) => {
    try {
        const day = req.params.day;
        const result = await pool.query(`
            SELECT
                Business.Name,
                Deal.Title,
                DealSchedule.DayOfWeek,
                DealSchedule.StartTime,
                DealSchedule.EndTime
            FROM Deal
            JOIN DealSchedule
                ON Deal.DealID = DealSchedule.DealID
            JOIN Business
                ON Deal.BusinessID = Business.BusinessID
            WHERE DealSchedule.DayOfWeek = $1
        `, [day]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// GET DEALS BY CATEGORY
const getDealsByCategory = async (req, res) => {
    try {
        const category = req.params.category;
        const result = await pool.query(`
            SELECT
                Business.Name,
                Deal.Title,
                Deal.Description,
                Category.CategoryName
            FROM DealCategory
            JOIN Deal
                ON DealCategory.DealID = Deal.DealID
            JOIN Business
                ON Deal.BusinessID = Business.BusinessID
            JOIN Category
                ON DealCategory.CategoryID = Category.CategoryID
            WHERE Category.CategoryName = $1
        `, [category]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// DEALS BY LOCATION
const getDealsByLocation = async (req, res) => {
    try {
        const city = req.params.city;
        const result = await pool.query(`
            SELECT
                Business.Name,
                Deal.Title,
                Deal.Description,
                Location.City,
                Business.Website,
                STRING_AGG(
                    DealSchedule.DayOfWeek,
                    ', '
                    ORDER BY 
                        CASE DealSchedule.DayOfWeek
                            WHEN 'Sunday' THEN 1
                            WHEN 'Monday' THEN 2
                            WHEN 'Tuesday' THEN 3
                            WHEN 'Wednesday' THEN 4
                            WHEN 'Thursday' THEN 5
                            WHEN 'Friday' THEN 6
                            WHEN 'Saturday' THEN 7
                        END
                ) AS DayOfWeek,
                MIN(DealSchedule.StartTime) AS StartTime,
                MAX(DealSchedule.EndTime) AS EndTime
            FROM Deal
            JOIN DealSchedule
                ON Deal.DealID = DealSchedule.DealID
            JOIN Business
                ON Deal.BusinessID = Business.BusinessID
            JOIN BusinessLocation
                ON Business.BusinessID = BusinessLocation.BusinessID
            JOIN Location
                ON BusinessLocation.LocationID = Location.LocationID
            WHERE Location.City = $1
            GROUP BY
                Business.Name,
                Deal.Title,
                Deal.Description,
                Location.City,
                Business.Website
            ORDER BY Business.Name
        `, [city]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// GET DEALS BY LOCATION & CATEGORY
const getDealsByLocationAndCategory = async (req, res) => {
    try {
        const city = req.params.city;
        const category = req.params.category;
        const result = await pool.query(`
            SELECT
                Business.Name,
                Deal.Title,
                Deal.Description,
                Category.CategoryName,
                Location.City,
                Business.Website,
                STRING_AGG(
                    DealSchedule.DayOfWeek,
                    ', '
                    ORDER BY 
                            CASE DealSchedule.DayOfWeek
                            WHEN 'Sunday' THEN 1
                            WHEN 'Monday' THEN 2
                            WHEN 'Tuesday' THEN 3
                            WHEN 'Wednesday' THEN 4
                            WHEN 'Thursday' THEN 5
                            WHEN 'Friday' THEN 6
                            WHEN 'Saturday' THEN 7
                            END
                ) AS DayOfWeek,
                MIN(DealSchedule.StartTime) AS StartTime,
                MAX(DealSchedule.EndTime) AS EndTime
            FROM Deal
            JOIN DealSchedule
                ON Deal.DealID = DealSchedule.DealID
            JOIN Business
                ON Deal.BusinessID = Business.BusinessID
            JOIN BusinessLocation
                ON Business.BusinessID = BusinessLocation.BusinessID
            JOIN Location
                ON BusinessLocation.LocationID = Location.LocationID
            JOIN DealCategory
                ON Deal.DealID = DealCategory.DealID
            JOIN Category
                ON DealCategory.CategoryID = Category.CategoryID
            WHERE Location.City = $1
              AND Category.CategoryName = $2
            GROUP BY
                Business.Name,
                Deal.Title,
                Deal.Description,
                Category.CategoryName,
                Location.City,
                Business.Website
            ORDER BY Business.Name
        `, [city, category]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// GET DEALS BY LOCATION AND DAY
const getDealsByLocationAndDay = async (req, res) => {
    try {
        const city = req.params.city;
        const day = req.params.day;
        const result = await pool.query(`
            SELECT
                Business.Name,
                Deal.Title,
                Deal.Description,
                DealSchedule.DayOfWeek,
                DealSchedule.StartTime,
                DealSchedule.EndTime,
                Location.City,
                Business.Website
            FROM Deal
            JOIN Business
                ON Deal.BusinessID = Business.BusinessID
            JOIN BusinessLocation
                ON Business.BusinessID = BusinessLocation.BusinessID
            JOIN Location
                ON BusinessLocation.LocationID = Location.LocationID
            JOIN DealSchedule
                ON Deal.DealID = DealSchedule.DealID
            WHERE Location.City = $1
              AND DealSchedule.DayOfWeek = $2
            ORDER BY Business.Name
        `, [city, day]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// GET DEALS BY LOCATION, CATEGORY, & DAY
const getDealsByLocationCategoryAndDay = async (req, res) => {
    try {
        const city = req.params.city;
        const category = req.params.category;
        const day = req.params.day;
        const result = await pool.query(`
            SELECT
                Business.Name,
                Deal.Title,
                Deal.Description,
                Category.CategoryName,
                DealSchedule.DayOfWeek,
                DealSchedule.StartTime,
                DealSchedule.EndTime,
                Location.City,
                Business.Website
            FROM Deal
            JOIN Business
                ON Deal.BusinessID = Business.BusinessID
            JOIN BusinessLocation
                ON Business.BusinessID = BusinessLocation.BusinessID
            JOIN Location
                ON BusinessLocation.LocationID = Location.LocationID
            JOIN DealCategory
                ON Deal.DealID = DealCategory.DealID
            JOIN Category
                ON DealCategory.CategoryID = Category.CategoryID
            JOIN DealSchedule
                ON Deal.DealID = DealSchedule.DealID
            WHERE Location.City = $1
              AND Category.CategoryName = $2
              AND DealSchedule.DayOfWeek = $3
            ORDER BY Business.Name
        `, [city, category, day]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

module.exports = {
    getAllDeals,
    getDealsByDay,
    getDealsByCategory,
    getDealsByLocation,
    getDealsByLocationAndCategory,
    getDealsByLocationAndDay,
    getDealsByLocationCategoryAndDay
};