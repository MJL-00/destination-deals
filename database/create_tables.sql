-- ============================================================
-- DESTINATION DEALS — Master Schema
-- Last updated: July 2026
-- Reflects all migrations v1-v7
-- ============================================================

-- ── Core lookup tables ────────────────────────────────────────

CREATE TABLE IF NOT EXISTS Category (
    CategoryID   SERIAL PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Location (
    LocationID  SERIAL PRIMARY KEY,
    City        VARCHAR(100) NOT NULL,
    State       VARCHAR(50),
    Description TEXT
);

-- ── Business ──────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS Business (
    BusinessID             SERIAL PRIMARY KEY,
    Name                   VARCHAR(150) NOT NULL,
    Address                VARCHAR(255),
    Phone                  VARCHAR(20),
    Website                VARCHAR(255),
    subscription_tier      VARCHAR(20)  NOT NULL DEFAULT 'Basic',
    is_verified            BOOLEAN      NOT NULL DEFAULT FALSE,
    directions_click_count INTEGER      NOT NULL DEFAULT 0,
    website_click_count    INTEGER      NOT NULL DEFAULT 0,
    latitude               DECIMAL(9,6),
    longitude              DECIMAL(9,6),
    outdoor_dining         BOOLEAN      NOT NULL DEFAULT FALSE,
    live_music             BOOLEAN      NOT NULL DEFAULT FALSE,
    waterfront             BOOLEAN      NOT NULL DEFAULT FALSE,
    pet_friendly           BOOLEAN      NOT NULL DEFAULT FALSE,
    CONSTRAINT chk_subscription_tier CHECK (subscription_tier IN ('Basic','Premium'))
);

-- ── Deal ──────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS Deal (
    DealID           SERIAL PRIMARY KEY,
    BusinessID       INT NOT NULL REFERENCES Business(BusinessID),
    Title            VARCHAR(150) NOT NULL,
    Description      TEXT,
    DiscountType     VARCHAR(50),
    DiscountValue    DECIMAL(10,2),
    IsActive         BOOLEAN      NOT NULL DEFAULT TRUE,
    startdate        DATE,
    enddate          DATE,
    click_count      INTEGER      NOT NULL DEFAULT 0,
    redemption_count INTEGER      NOT NULL DEFAULT 0,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ── Junction tables ───────────────────────────────────────────

CREATE TABLE IF NOT EXISTS BusinessCategory (
    BusinessID INT NOT NULL REFERENCES Business(BusinessID),
    CategoryID INT NOT NULL REFERENCES Category(CategoryID),
    PRIMARY KEY (BusinessID, CategoryID)
);

CREATE TABLE IF NOT EXISTS BusinessLocation (
    BusinessID INT NOT NULL REFERENCES Business(BusinessID),
    LocationID INT NOT NULL REFERENCES Location(LocationID),
    PRIMARY KEY (BusinessID, LocationID)
);

CREATE TABLE IF NOT EXISTS DealCategory (
    DealID     INT NOT NULL REFERENCES Deal(DealID),
    CategoryID INT NOT NULL REFERENCES Category(CategoryID),
    PRIMARY KEY (DealID, CategoryID)
);

CREATE TABLE IF NOT EXISTS DealSchedule (
    ScheduleID SERIAL PRIMARY KEY,
    DealID     INT NOT NULL REFERENCES Deal(DealID),
    DayOfWeek  VARCHAR(15),
    StartTime  TIME,
    EndTime    TIME
);

-- ── CRM (migration v5) ────────────────────────────────────────

CREATE TABLE IF NOT EXISTS prospect (
    prospectid     SERIAL PRIMARY KEY,
    business_name  VARCHAR(150) NOT NULL,
    address        VARCHAR(255),
    city           VARCHAR(100),
    state          VARCHAR(50),
    phone          VARCHAR(20),
    website        VARCHAR(255),
    contact_name   VARCHAR(100),
    contact_email  VARCHAR(150),
    category_notes TEXT,
    status         VARCHAR(30)  NOT NULL DEFAULT 'not_approached',
    assigned_to    VARCHAR(100),
    businessid     INT REFERENCES Business(BusinessID) ON DELETE SET NULL,
    created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    follow_up_date DATE,
    CONSTRAINT chk_prospect_status CHECK (status IN (
        'not_approached',
        'initial_contact_made',
        'follow_up_required',
        'waiting_for_response',
        'deal_setup_pending',
        'converted',
        'not_interested',
        'no_response'
    ))
);

CREATE TABLE IF NOT EXISTS prospect_note (
    noteid     SERIAL PRIMARY KEY,
    prospectid INT NOT NULL REFERENCES prospect(prospectid) ON DELETE CASCADE,
    note       TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION fn_prospect_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_prospect_updated_at ON prospect;
CREATE TRIGGER trg_prospect_updated_at
    BEFORE UPDATE ON prospect
    FOR EACH ROW EXECUTE FUNCTION fn_prospect_updated_at();

-- ── Page view tracking (migration v6) ────────────────────────

CREATE TABLE IF NOT EXISTS page_view (
    viewid    SERIAL PRIMARY KEY,
    city      VARCHAR(100) NOT NULL,
    state     VARCHAR(50),
    ip_hash   VARCHAR(64),
    device_id VARCHAR(64),
    viewed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Timestamped click tracking (migration v7) ─────────────────

CREATE TABLE IF NOT EXISTS business_click (
    clickid    SERIAL PRIMARY KEY,
    businessid INT NOT NULL REFERENCES Business(BusinessID) ON DELETE CASCADE,
    click_type VARCHAR(20) NOT NULL CHECK (click_type IN ('website','directions')),
    device_id  VARCHAR(64),
    clicked_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Indexes ───────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_prospect_status      ON prospect(status);
CREATE INDEX IF NOT EXISTS idx_prospect_note_pid    ON prospect_note(prospectid);
CREATE INDEX IF NOT EXISTS idx_pageview_city_date   ON page_view(city, viewed_at);
CREATE INDEX IF NOT EXISTS idx_pageview_device_city ON page_view(device_id, city, viewed_at);
CREATE INDEX IF NOT EXISTS idx_bclick_business_date ON business_click(businessid, clicked_at);
CREATE INDEX IF NOT EXISTS idx_bclick_device        ON business_click(device_id, businessid, clicked_at);