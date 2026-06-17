-- ============================================================
-- DESTINATION DEALS — Migration v2: Drop Redundant Location
--                     Columns from Business Table
-- ============================================================
-- Safe to run: columns are confirmed unread and unwritten
-- across all controllers, routes, and frontend forms.
-- ============================================================

ALTER TABLE business
    DROP COLUMN IF EXISTS city,
    DROP COLUMN IF EXISTS state,
    DROP COLUMN IF EXISTS zipcode;

-- ── Verify: these three should NOT appear in the results ─────
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'business'
ORDER BY ordinal_position;
