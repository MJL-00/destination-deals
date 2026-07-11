const express = require('express');
const router  = express.Router();
const pool    = require('../db');
const crypto  = require('crypto');

// ── POST /pageviews/city ──────────────────────────────────────
// Called when user loads deals for a city.
// Deduplicates: one record per device per city per day.
router.post('/city', async (req, res) => {
    const { city, state, device_id } = req.body;
    if (!city || !device_id) {
        return res.status(400).json({ error: 'city and device_id required' });
    }

    // Hash the IP for privacy — never store raw IP
    const rawIp  = req.headers['x-forwarded-for']?.split(',')[0]?.trim()
                   || req.socket.remoteAddress || 'unknown';
    const ipHash = crypto.createHash('sha256').update(rawIp).digest('hex');

    try {
        // Deduplicate: skip if same device already logged this city today
        const today = new Date().toISOString().slice(0, 10);
        const existing = await pool.query(`
            SELECT viewid FROM page_view
            WHERE device_id = $1
              AND city = $2
              AND viewed_at::date = $3::date
            LIMIT 1
        `, [device_id, city, today]);

        if (existing.rows.length === 0) {
            await pool.query(`
                INSERT INTO page_view (city, state, ip_hash, device_id)
                VALUES ($1, $2, $3, $4)
            `, [city, state || null, ipHash, device_id]);
        }

        res.json({ success: true });
    } catch (err) {
        if (err.code === '42P01') {
            // Table doesn't exist yet — migration v6 not run
            return res.json({ success: false, message: 'page_view table not yet created' });
        }
        console.error('pageview error:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ── GET /pageviews/monthly?city=Newport&year=2026&month=6 ─────
// Returns unique device count for a city in a given month
router.get('/monthly', async (req, res) => {
    const { city, year, month } = req.query;
    if (!city || !year || !month) {
        return res.status(400).json({ error: 'city, year, month required' });
    }

    try {
        const [weeklyResult, totalResult] = await Promise.all([
            pool.query(`
                SELECT
                    DATE_TRUNC('week', viewed_at) AS week_start,
                    COUNT(DISTINCT device_id)     AS weekly_devices
                FROM page_view
                WHERE city = $1
                  AND EXTRACT(YEAR  FROM viewed_at) = $2
                  AND EXTRACT(MONTH FROM viewed_at) = $3
                GROUP BY DATE_TRUNC('week', viewed_at)
                ORDER BY week_start
            `, [city, parseInt(year), parseInt(month)]),
            pool.query(`
                SELECT COUNT(DISTINCT device_id) AS total_devices
                FROM page_view
                WHERE city = $1
                  AND EXTRACT(YEAR  FROM viewed_at) = $2
                  AND EXTRACT(MONTH FROM viewed_at) = $3
            `, [city, parseInt(year), parseInt(month)])
        ]);

        res.json({
            city,
            year:          parseInt(year),
            month:         parseInt(month),
            total_devices: parseInt(totalResult.rows[0]?.total_devices || 0),
            weekly:        weeklyResult.rows
        });
    } catch (err) {
        console.error('pageview monthly error:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ── GET /pageviews/city-clicks?city=Newport&year=2026&month=6
// Returns monthly click totals for every business in a city
// Used for ranking sections in monthly reports
router.get('/city-clicks', async (req, res) => {
    const { city, year, month } = req.query;
    if (!city || !year || !month) {
        return res.status(400).json({ error: 'city, year, month required' });
    }

    try {
        const result = await pool.query(`
            SELECT
                bc.businessid,
                SUM(CASE WHEN bc.click_type = 'website'    THEN 1 ELSE 0 END) AS website_clicks,
                SUM(CASE WHEN bc.click_type = 'directions' THEN 1 ELSE 0 END) AS directions_clicks,
                COUNT(*) AS total_clicks
            FROM business_click bc
            JOIN businesslocation bl ON bc.businessid = bl.businessid
            JOIN location l          ON bl.locationid = l.locationid
            WHERE l.city = $1
              AND EXTRACT(YEAR  FROM bc.clicked_at) = $2
              AND EXTRACT(MONTH FROM bc.clicked_at) = $3
            GROUP BY bc.businessid
        `, [city, parseInt(year), parseInt(month)]);

        res.json(result.rows);
    } catch (err) {
        if (err.code === '42P01') return res.json([]);
        console.error('city-clicks error:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

// ── GET /pageviews/clicks?businessid=1&year=2026&month=6 ─────
// Returns weekly click breakdown for a specific business/month
router.get('/clicks', async (req, res) => {
    const { businessid, year, month } = req.query;
    if (!businessid || !year || !month) {
        return res.status(400).json({ error: 'businessid, year, month required' });
    }

    try {
        const result = await pool.query(`
            SELECT
                DATE_TRUNC('week', clicked_at) AS week_start,
                click_type,
                COUNT(*)                        AS clicks
            FROM business_click
            WHERE businessid                    = $1
              AND EXTRACT(YEAR  FROM clicked_at) = $2
              AND EXTRACT(MONTH FROM clicked_at) = $3
            GROUP BY week_start, click_type
            ORDER BY week_start, click_type
        `, [parseInt(businessid), parseInt(year), parseInt(month)]);

        // Also get monthly totals
        const totals = await pool.query(`
            SELECT
                click_type,
                COUNT(*) AS total
            FROM business_click
            WHERE businessid                    = $1
              AND EXTRACT(YEAR  FROM clicked_at) = $2
              AND EXTRACT(MONTH FROM clicked_at) = $3
            GROUP BY click_type
        `, [parseInt(businessid), parseInt(year), parseInt(month)]);

        res.json({
            businessid: parseInt(businessid),
            year:       parseInt(year),
            month:      parseInt(month),
            weekly:     result.rows,
            totals:     totals.rows
        });
    } catch (err) {
        if (err.code === '42P01') {
            return res.json({ weekly: [], totals: [] });
        }
        console.error('clicks monthly error:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;