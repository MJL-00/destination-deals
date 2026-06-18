const pool = require('../db');

// ── GET DEALS BY DAY ──────────────────────────────────────────
const getDealsByDay = async (req, res) => {
    try {
        const day = req.params.day;
        const result = await pool.query(`
            SELECT
                Business.BusinessID,
                Business.Name,
                Business.Address,
                Business.Phone,
                Business.Website,
                Business.latitude,
                Business.longitude,
                Deal.Title,
                Deal.Description,
                Deal.DiscountType,
                Deal.DiscountValue,
                DealSchedule.DayOfWeek,
                DealSchedule.StartTime,
                DealSchedule.EndTime,
                STRING_AGG(DISTINCT Category.CategoryName, ', ') AS categories
            FROM Deal
            JOIN DealSchedule      ON Deal.DealID          = DealSchedule.DealID
            JOIN Business          ON Deal.BusinessID       = Business.BusinessID
            LEFT JOIN DealCategory ON Deal.DealID           = DealCategory.DealID
            LEFT JOIN Category     ON DealCategory.CategoryID = Category.CategoryID
            WHERE DealSchedule.DayOfWeek = $1
            GROUP BY
                Business.BusinessID, Business.Name, Business.Address, Business.Phone,
                Business.Website, Business.latitude, Business.longitude,
                Deal.Title, Deal.Description, Deal.DiscountType, Deal.DiscountValue,
                DealSchedule.DayOfWeek, DealSchedule.StartTime, DealSchedule.EndTime
        `, [day]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// ── GET DEALS BY CATEGORY ─────────────────────────────────────
const getDealsByCategory = async (req, res) => {
    try {
        const category = req.params.category;
        const result = await pool.query(`
            SELECT
                Business.BusinessID,
                Business.Name,
                Business.Address,
                Business.Phone,
                Business.Website,
                Business.latitude,
                Business.longitude,
                Deal.Title,
                Deal.Description,
                Deal.DiscountType,
                Deal.DiscountValue,
                STRING_AGG(DISTINCT Category.CategoryName, ', ') AS categories
            FROM DealCategory
            JOIN Deal     ON DealCategory.DealID     = Deal.DealID
            JOIN Business ON Deal.BusinessID          = Business.BusinessID
            JOIN Category ON DealCategory.CategoryID  = Category.CategoryID
            WHERE Category.CategoryName = $1
            GROUP BY
                Business.BusinessID, Business.Name, Business.Address, Business.Phone,
                Business.Website, Business.latitude, Business.longitude,
                Deal.Title, Deal.Description, Deal.DiscountType, Deal.DiscountValue
        `, [category]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// ── GET DEALS BY LOCATION ─────────────────────────────────────
const getDealsByLocation = async (req, res) => {
    try {
        const city = req.params.city;
        const result = await pool.query(`
            SELECT
                Business.BusinessID,
                Business.Name,
                Business.Address,
                Business.Phone,
                Business.Website,
                Business.latitude,
                Business.longitude,
                Deal.Title,
                Deal.Description,
                Deal.DiscountType,
                Deal.DiscountValue,
                Location.City,
                Location.State AS state,
                STRING_AGG(DISTINCT Category.CategoryName, ', ') AS categories,
                STRING_AGG(
                    DISTINCT DealSchedule.DayOfWeek,
                    ', '
                    ORDER BY DealSchedule.DayOfWeek
                ) AS DayOfWeek,
                MIN(DealSchedule.StartTime) AS StartTime,
                MAX(DealSchedule.EndTime)   AS EndTime
            FROM Deal
            JOIN DealSchedule     ON Deal.DealID             = DealSchedule.DealID
            JOIN Business         ON Deal.BusinessID          = Business.BusinessID
            JOIN BusinessLocation ON Business.BusinessID      = BusinessLocation.BusinessID
            JOIN Location         ON BusinessLocation.LocationID = Location.LocationID
            LEFT JOIN DealCategory ON Deal.DealID             = DealCategory.DealID
            LEFT JOIN Category     ON DealCategory.CategoryID  = Category.CategoryID
            WHERE Location.City = $1
            GROUP BY
                Business.BusinessID, Business.Name, Business.Address, Business.Phone,
                Business.Website, Business.latitude, Business.longitude,
                Deal.Title, Deal.Description, Deal.DiscountType, Deal.DiscountValue,
                Location.City, Location.State
            ORDER BY Business.Name
        `, [city]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// ── GET DEALS BY LOCATION & CATEGORY ─────────────────────────
const getDealsByLocationAndCategory = async (req, res) => {
    try {
        const city     = req.params.city;
        const category = req.params.category;
        const result = await pool.query(`
            SELECT
                Business.BusinessID,
                Business.Name,
                Business.Address,
                Business.Phone,
                Business.Website,
                Business.latitude,
                Business.longitude,
                Deal.Title,
                Deal.Description,
                Deal.DiscountType,
                Deal.DiscountValue,
                Location.City,
                Location.State AS state,
                STRING_AGG(DISTINCT Category.CategoryName, ', ') AS categories,
                STRING_AGG(
                    DISTINCT DealSchedule.DayOfWeek,
                    ', '
                    ORDER BY DealSchedule.DayOfWeek
                ) AS DayOfWeek,
                MIN(DealSchedule.StartTime) AS StartTime,
                MAX(DealSchedule.EndTime)   AS EndTime
            FROM Deal
            JOIN DealSchedule     ON Deal.DealID              = DealSchedule.DealID
            JOIN Business         ON Deal.BusinessID           = Business.BusinessID
            JOIN BusinessLocation ON Business.BusinessID       = BusinessLocation.BusinessID
            JOIN Location         ON BusinessLocation.LocationID  = Location.LocationID
            JOIN DealCategory     ON Deal.DealID               = DealCategory.DealID
            JOIN Category         ON DealCategory.CategoryID   = Category.CategoryID
            WHERE Location.City        = $1
              AND Category.CategoryName = $2
            GROUP BY
                Business.BusinessID, Business.Name, Business.Address, Business.Phone,
                Business.Website, Business.latitude, Business.longitude,
                Deal.Title, Deal.Description, Deal.DiscountType, Deal.DiscountValue,
                Location.City, Location.State
            ORDER BY Business.Name
        `, [city, category]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// ── GET DEALS BY LOCATION & DAY ───────────────────────────────
const getDealsByLocationAndDay = async (req, res) => {
    try {
        const city = req.params.city;
        const day  = req.params.day;
        const result = await pool.query(`
            SELECT
                Business.BusinessID,
                Business.Name,
                Business.Address,
                Business.Phone,
                Business.Website,
                Business.latitude,
                Business.longitude,
                Deal.Title,
                Deal.Description,
                Deal.DiscountType,
                Deal.DiscountValue,
                DealSchedule.DayOfWeek,
                DealSchedule.StartTime,
                DealSchedule.EndTime,
                Location.City,
                Location.State AS state,
                STRING_AGG(DISTINCT Category.CategoryName, ', ') AS categories
            FROM Deal
            JOIN Business          ON Deal.BusinessID          = Business.BusinessID
            JOIN BusinessLocation  ON Business.BusinessID      = BusinessLocation.BusinessID
            JOIN Location          ON BusinessLocation.LocationID = Location.LocationID
            JOIN DealSchedule      ON Deal.DealID              = DealSchedule.DealID
            LEFT JOIN DealCategory ON Deal.DealID              = DealCategory.DealID
            LEFT JOIN Category     ON DealCategory.CategoryID  = Category.CategoryID
            WHERE Location.City        = $1
              AND DealSchedule.DayOfWeek = $2
            GROUP BY
                Business.BusinessID, Business.Name, Business.Address, Business.Phone,
                Business.Website, Business.latitude, Business.longitude,
                Deal.Title, Deal.Description, Deal.DiscountType, Deal.DiscountValue,
                DealSchedule.DayOfWeek, DealSchedule.StartTime, DealSchedule.EndTime,
                Location.City, Location.State
            ORDER BY Business.Name
        `, [city, day]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// ── GET DEALS BY LOCATION, CATEGORY & DAY ────────────────────
const getDealsByLocationCategoryAndDay = async (req, res) => {
    try {
        const city     = req.params.city;
        const category = req.params.category;
        const day      = req.params.day;
        const result = await pool.query(`
            SELECT
                Business.BusinessID,
                Business.Name,
                Business.Address,
                Business.Phone,
                Business.Website,
                Business.latitude,
                Business.longitude,
                Deal.Title,
                Deal.Description,
                Deal.DiscountType,
                Deal.DiscountValue,
                Location.City,
                Location.State AS state,
                STRING_AGG(DISTINCT Category.CategoryName, ', ') AS categories,
                DealSchedule.DayOfWeek,
                DealSchedule.StartTime,
                DealSchedule.EndTime
            FROM Deal
            JOIN Business         ON Deal.BusinessID          = Business.BusinessID
            JOIN BusinessLocation ON Business.BusinessID      = BusinessLocation.BusinessID
            JOIN Location         ON BusinessLocation.LocationID = Location.LocationID
            JOIN DealCategory     ON Deal.DealID              = DealCategory.DealID
            JOIN Category         ON DealCategory.CategoryID  = Category.CategoryID
            JOIN DealSchedule     ON Deal.DealID              = DealSchedule.DealID
            WHERE Location.City        = $1
              AND Category.CategoryName = $2
              AND DealSchedule.DayOfWeek = $3
            GROUP BY
                Business.BusinessID, Business.Name, Business.Address, Business.Phone,
                Business.Website, Business.latitude, Business.longitude,
                Deal.Title, Deal.Description, Deal.DiscountType, Deal.DiscountValue,
                Location.City, Location.State,
                DealSchedule.DayOfWeek, DealSchedule.StartTime, DealSchedule.EndTime
            ORDER BY Business.Name
        `, [city, category, day]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server Error');
    }
};

// ── CREATE DEAL (with categories + schedule) ──────────────────
const createDeal = async (req, res) => {
    const {
        businessid, title, description, discounttype,
        discountvalue, isactive, categoryIds, activeDays,
        starttime, endtime
    } = req.body;

    if (!businessid || !title || !discounttype || !activeDays || activeDays.length === 0) {
        return res.status(400).json({ error: "Missing required parameters or scheduled days." });
    }

    const client = await pool.connect();
    try {
        await client.query('BEGIN');

        const dealResult = await client.query(`
            INSERT INTO deal (businessid, title, description, discounttype, discountvalue, isactive)
            VALUES ($1, $2, $3, $4, $5, $6)
            RETURNING dealid;
        `, [businessid, title, description, discounttype, discountvalue, isactive ?? true]);

        const newDealId = dealResult.rows[0].dealid;

        if (categoryIds && categoryIds.length > 0) {
            for (const catId of categoryIds) {
                await client.query(
                    'INSERT INTO dealcategory (dealid, categoryid) VALUES ($1, $2)',
                    [newDealId, catId]
                );
            }
        }

        for (const day of activeDays) {
            await client.query(
                'INSERT INTO dealschedule (dealid, dayofweek, starttime, endtime) VALUES ($1, $2, $3, $4)',
                [newDealId, day, starttime, endtime]
            );
        }

        await client.query('COMMIT');
        res.status(201).json({
            message: "Deal, category attachments, and active schedules created successfully!",
            dealid: newDealId
        });
    } catch (err) {
        await client.query('ROLLBACK');
        console.error("Transaction Error in createDeal:", err);
        if (err.code === '23503') {
            return res.status(400).json({ error: "Invalid record constraints. Check database keys." });
        }
        res.status(500).json({ error: "Server Error parsing deal scheduling entries." });
    } finally {
        client.release();
    }
};

// ── GET SINGLE DEAL BY ID (admin) ─────────────────────────────
const getDealById = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query(`
            SELECT
                d.*,
                b.name AS business_name,
                STRING_AGG(DISTINCT c.categoryname, ', ') AS categories,
                STRING_AGG(DISTINCT ds.dayofweek, ', '
                    ORDER BY ds.dayofweek) AS days,
                MIN(ds.starttime) AS starttime,
                MAX(ds.endtime)   AS endtime
            FROM deal d
            JOIN business b        ON d.businessid  = b.businessid
            LEFT JOIN dealcategory dc ON d.dealid   = dc.dealid
            LEFT JOIN category     c  ON dc.categoryid = c.categoryid
            LEFT JOIN dealschedule ds ON d.dealid   = ds.dealid
            WHERE d.dealid = $1
            GROUP BY d.dealid, b.name
        `, [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Deal not found.' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// ── GET ALL DEALS ENRICHED (admin list page) ──────────────────
const getAllDealsEnriched = async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT
                d.*,
                b.name AS business_name,
                STRING_AGG(DISTINCT c.categoryname, ', ') AS categories,
                STRING_AGG(DISTINCT ds.dayofweek, ', '
                    ORDER BY ds.dayofweek) AS days,
                MIN(ds.starttime) AS starttime,
                MAX(ds.endtime)   AS endtime
            FROM deal d
            JOIN business b        ON d.businessid  = b.businessid
            LEFT JOIN dealcategory dc ON d.dealid   = dc.dealid
            LEFT JOIN category     c  ON dc.categoryid = c.categoryid
            LEFT JOIN dealschedule ds ON d.dealid   = ds.dealid
            GROUP BY d.dealid, b.name
            ORDER BY d.dealid DESC
        `);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// ── TOGGLE isactive FLAG ──────────────────────────────────────
const toggleDealActive = async (req, res) => {
    const { id } = req.params;
    const { isactive } = req.body;
    try {
        const result = await pool.query(
            'UPDATE deal SET isactive = $1 WHERE dealid = $2 RETURNING dealid, title, isactive',
            [isactive, id]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Deal not found.' });
        }
        res.json({
            message: `Deal ${isactive ? 'activated' : 'deactivated'} successfully.`,
            deal: result.rows[0]
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error updating deal status.' });
    }
};

// ── DELETE DEAL (cascade junction rows) ───────────────────────
const deleteDeal = async (req, res) => {
    const { id } = req.params;
    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        await client.query('DELETE FROM dealcategory WHERE dealid = $1', [id]);
        await client.query('DELETE FROM dealschedule WHERE dealid = $1', [id]);
        const result = await client.query(
            'DELETE FROM deal WHERE dealid = $1 RETURNING dealid, title',
            [id]
        );
        if (result.rows.length === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Deal not found.' });
        }
        await client.query('COMMIT');
        res.json({ message: `Deal "${result.rows[0].title}" deleted successfully.` });
    } catch (err) {
        await client.query('ROLLBACK');
        console.error(err);
        res.status(500).json({ error: 'Server error deleting deal.' });
    } finally {
        client.release();
    }
};

// ── EXPORTS ───────────────────────────────────────────────────
module.exports = {
    getAllDealsEnriched,
    getDealsByDay,
    getDealsByCategory,
    getDealsByLocation,
    getDealsByLocationAndCategory,
    getDealsByLocationAndDay,
    getDealsByLocationCategoryAndDay,
    createDeal,
    getDealById,
    toggleDealActive,
    deleteDeal
};