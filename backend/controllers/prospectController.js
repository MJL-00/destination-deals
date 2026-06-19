const pool = require('../db');

const VALID_STATUSES = [
    'not_approached',
    'initial_contact_made',
    'follow_up_required',
    'waiting_for_response',
    'deal_setup_pending',
    'converted',
    'not_interested',
    'no_response'
];

// ── GET ALL PROSPECTS ─────────────────────────────────────────
const getAllProspects = async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT
                p.*,
                -- Most recent note inline
                (SELECT n.note FROM prospect_note n
                 WHERE n.prospectid = p.prospectid
                 ORDER BY n.created_at DESC LIMIT 1) AS latest_note,
                (SELECT n.created_at FROM prospect_note n
                 WHERE n.prospectid = p.prospectid
                 ORDER BY n.created_at DESC LIMIT 1) AS latest_note_at,
                -- Count of all notes
                (SELECT COUNT(*) FROM prospect_note n
                 WHERE n.prospectid = p.prospectid) AS note_count
            FROM prospect p
            ORDER BY
                CASE p.status
                    WHEN 'deal_setup_pending'    THEN 1
                    WHEN 'follow_up_required'    THEN 2
                    WHEN 'waiting_for_response'  THEN 3
                    WHEN 'initial_contact_made'  THEN 4
                    WHEN 'not_approached'        THEN 5
                    WHEN 'converted'             THEN 6
                    WHEN 'no_response'           THEN 7
                    WHEN 'not_interested'        THEN 8
                END,
                p.updated_at DESC
        `);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// ── GET NOTES FOR A PROSPECT ──────────────────────────────────
const getProspectNotes = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    try {
        const result = await pool.query(
            'SELECT * FROM prospect_note WHERE prospectid = $1 ORDER BY created_at DESC',
            [id]
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// ── CREATE PROSPECT ───────────────────────────────────────────
const createProspect = async (req, res) => {
    const {
        business_name, address, city, state, phone,
        website, contact_name, contact_email,
        category_notes, assigned_to
    } = req.body;

    if (!business_name) {
        return res.status(400).json({ error: 'Business name is required.' });
    }

    try {
        const result = await pool.query(`
            INSERT INTO prospect
                (business_name, address, city, state, phone, website,
                 contact_name, contact_email, category_notes, assigned_to)
            VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)
            RETURNING *
        `, [business_name, address || null, city || null, state || null,
            phone || null, website || null, contact_name || null,
            contact_email || null, category_notes || null, assigned_to || null]);

        res.status(201).json({ message: 'Prospect added.', prospect: result.rows[0] });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// ── UPDATE PROSPECT STATUS ────────────────────────────────────
const updateStatus = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    const { status } = req.body;

    if (!VALID_STATUSES.includes(status)) {
        return res.status(400).json({ error: 'Invalid status value.' });
    }

    try {
        const result = await pool.query(
            'UPDATE prospect SET status = $1 WHERE prospectid = $2 RETURNING *',
            [status, id]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Prospect not found.' });
        }
        res.json({ message: 'Status updated.', prospect: result.rows[0] });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// ── UPDATE PROSPECT DETAILS ───────────────────────────────────
const updateProspect = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    const {
        business_name, address, city, state, phone,
        website, contact_name, contact_email, category_notes, assigned_to
    } = req.body;

    try {
        const result = await pool.query(`
            UPDATE prospect SET
                business_name  = COALESCE($1,  business_name),
                address        = $2,
                city           = $3,
                state          = $4,
                phone          = $5,
                website        = $6,
                contact_name   = $7,
                contact_email  = $8,
                category_notes = $9,
                assigned_to    = $10
            WHERE prospectid = $11
            RETURNING *
        `, [business_name, address || null, city || null, state || null,
            phone || null, website || null, contact_name || null,
            contact_email || null, category_notes || null,
            assigned_to || null, id]);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Prospect not found.' });
        }
        res.json({ message: 'Prospect updated.', prospect: result.rows[0] });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// ── ADD NOTE ──────────────────────────────────────────────────
const addNote = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    const { note } = req.body;

    if (!note || !note.trim()) {
        return res.status(400).json({ error: 'Note text is required.' });
    }

    try {
        const result = await pool.query(
            'INSERT INTO prospect_note (prospectid, note) VALUES ($1, $2) RETURNING *',
            [id, note.trim()]
        );
        // Touch updated_at on the parent prospect
        await pool.query(
            'UPDATE prospect SET updated_at = NOW() WHERE prospectid = $1', [id]
        );
        res.status(201).json({ message: 'Note added.', note: result.rows[0] });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// ── UPDATE FOLLOW-UP DATE ────────────────────────────────────
const updateFollowUpDate = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    const { follow_up_date } = req.body;
    try {
        const result = await pool.query(
            'UPDATE prospect SET follow_up_date = $1 WHERE prospectid = $2 RETURNING *',
            [follow_up_date || null, id]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Prospect not found.' });
        }
        res.json({ message: 'Follow-up date updated.', prospect: result.rows[0] });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server Error' });
    }
};

// ── DELETE PROSPECT ───────────────────────────────────────────
const deleteProspect = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    try {
        const result = await pool.query(
            'DELETE FROM prospect WHERE prospectid = $1 RETURNING business_name',
            [id]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Prospect not found.' });
        }
        res.json({ message: `"${result.rows[0].business_name}" removed from CRM.` });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server Error' });
    }
};

module.exports = {
    getAllProspects,
    getProspectNotes,
    createProspect,
    updateStatus,
    updateProspect,
    updateFollowUpDate,
    addNote,
    deleteProspect
};