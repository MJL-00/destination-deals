-- ============================================================
-- DESTINATION DEALS — Migration v1: MVP Metadata & Tracking
-- ============================================================
-- Run this in pgAdmin Query Tool against your target database.
-- Safe to re-run: all statements use IF NOT EXISTS / OR REPLACE.
-- ============================================================


-- ── 1. BUSINESS table additions ──────────────────────────────
--
--    subscription_tier  : 'Basic' or 'Premium' (default Basic)
--    is_verified        : admin flag for confirmed storefronts
--    directions_click_count : high-intent foot-traffic signal
--    website_click_count    : digital referral traffic signal

ALTER TABLE Business
    ADD COLUMN IF NOT EXISTS subscription_tier       VARCHAR(20)  NOT NULL DEFAULT 'Basic',
    ADD COLUMN IF NOT EXISTS is_verified             BOOLEAN      NOT NULL DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS directions_click_count  INTEGER      NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS website_click_count     INTEGER      NOT NULL DEFAULT 0;

-- Constrain tier to known values so bad data can't sneak in
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'chk_subscription_tier'
    ) THEN
        ALTER TABLE Business
            ADD CONSTRAINT chk_subscription_tier
            CHECK (subscription_tier IN ('Basic', 'Premium'));
    END IF;
END $$;


-- ── 2. DEAL table additions ───────────────────────────────────
--
--    click_count       : views/impressions on a deal card
--    redemption_count  : user tapped "I'm using this" — closes
--                        the funnel loop; most valuable metric
--    created_at        : enables trend reports ("90-day views")
--    updated_at        : auto-maintained by trigger below

ALTER TABLE Deal
    ADD COLUMN IF NOT EXISTS click_count       INTEGER      NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS redemption_count  INTEGER      NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    ADD COLUMN IF NOT EXISTS updated_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW();


-- ── 3. Auto-update trigger for Deal.updated_at ────────────────

CREATE OR REPLACE FUNCTION fn_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_deal_updated_at ON Deal;
CREATE TRIGGER trg_deal_updated_at
    BEFORE UPDATE ON Deal
    FOR EACH ROW
    EXECUTE FUNCTION fn_set_updated_at();


-- ── 4. Verification query — run this after to confirm ─────────

SELECT
    table_name,
    column_name,
    data_type,
    column_default
FROM information_schema.columns
WHERE table_name IN ('business', 'deal')
  AND column_name IN (
      'subscription_tier', 'is_verified',
      'directions_click_count', 'website_click_count',
      'click_count', 'redemption_count',
      'created_at', 'updated_at'
  )
ORDER BY table_name, column_name;
