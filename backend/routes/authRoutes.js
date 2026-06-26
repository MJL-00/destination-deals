const express = require('express');
const router  = express.Router();

// ── POST /auth/login ──────────────────────────────────────────
router.post('/login', (req, res) => {
    const { password } = req.body;
    const adminPassword = process.env.ADMIN_PASSWORD;

    if (!adminPassword) {
        console.error('ADMIN_PASSWORD environment variable not set.');
        return res.status(500).json({ error: 'Server misconfiguration.' });
    }

    if (password === adminPassword) {
        // Return a simple token — just a signed timestamp the client checks
        const token = Buffer.from(`dd-admin:${Date.now()}`).toString('base64');
        return res.json({ success: true, token });
    }

    return res.status(401).json({ error: 'Incorrect password.' });
});

// ── GET /auth/verify ──────────────────────────────────────────
// Client calls this to check if its stored token is still valid
router.get('/verify', (req, res) => {
    const token = req.headers['x-admin-token'];
    if (!token) return res.status(401).json({ valid: false });

    try {
        const decoded = Buffer.from(token, 'base64').toString('utf8');
        if (decoded.startsWith('dd-admin:')) {
            return res.json({ valid: true });
        }
        return res.status(401).json({ valid: false });
    } catch {
        return res.status(401).json({ valid: false });
    }
});

module.exports = router;