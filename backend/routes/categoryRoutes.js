const express = require('express');
const router = express.Router();
const pool = require('../db');

// 1. ADD THIS FOR THE PUBLIC HOME PAGE
// This handles: GET http://localhost:3000/categories
router.get('/', async (req, res) => {
    try {
        const result = await pool.query('SELECT categoryid, categoryname FROM category ORDER BY categoryname ASC');
        res.json(result.rows);
    } catch (err) {
        console.error("Error on public categories fetch:", err);
        res.status(500).send('Server Error');
    }
});

// 2. KEEP THIS FOR THE ADMIN PORTAL CHECKBOXES
// This handles: GET http://localhost:3000/categories/lookup
router.get('/lookup', async (req, res) => {
    try {
        const result = await pool.query('SELECT categoryid, categoryname FROM category ORDER BY categoryname ASC');
        res.json(result.rows);
    } catch (err) {
        console.error("Error on admin categories lookup:", err);
        res.status(500).send('Server Error');
    }
});

module.exports = router;