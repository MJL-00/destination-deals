-- ============================================
-- DESTINATION DEALS DATABASE
-- CREATE TABLE SCRIPT
-- ============================================

CREATE TABLE Category (
    CategoryID SERIAL PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

CREATE TABLE Location (
    LocationID SERIAL PRIMARY KEY,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Description VARCHAR(255)
);

CREATE TABLE Business (
    BusinessID              SERIAL PRIMARY KEY,
    Name                    VARCHAR(150) NOT NULL,
    Address                 VARCHAR(255),
    Phone                   VARCHAR(20),
    Website                 VARCHAR(255),
    subscription_tier       VARCHAR(20) NOT NULL DEFAULT 'Basic',
    is_verified             BOOLEAN NOT NULL DEFAULT FALSE,
    directions_click_count  INTEGER NOT NULL DEFAULT 0,
    website_click_count     INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT chk_subscription_tier CHECK (subscription_tier IN ('Basic', 'Premium'))
);

CREATE TABLE Deal (
    DealID          SERIAL PRIMARY KEY,
    BusinessID      INT NOT NULL,
    Title           VARCHAR(150) NOT NULL,
    Description     VARCHAR(255),
    DiscountType    VARCHAR(50),
    DiscountValue   DECIMAL(10,2),
    IsActive        BOOLEAN DEFAULT TRUE,
    click_count     INTEGER NOT NULL DEFAULT 0,
    redemption_count INTEGER NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (BusinessID) REFERENCES Business(BusinessID)
);

CREATE TABLE DealSchedule (
    ScheduleID SERIAL PRIMARY KEY,
    DealID INT NOT NULL,
    DayOfWeek VARCHAR(20),
    StartTime TIME,
    EndTime TIME,

    FOREIGN KEY (DealID)
        REFERENCES Deal(DealID)
);

CREATE TABLE BusinessCategory (
    BusinessID INT,
    CategoryID INT,

    PRIMARY KEY (BusinessID, CategoryID),

    FOREIGN KEY (BusinessID)
        REFERENCES Business(BusinessID),

    FOREIGN KEY (CategoryID)
        REFERENCES Category(CategoryID)
);

CREATE TABLE DealCategory (
    DealID INT,
    CategoryID INT,

    PRIMARY KEY (DealID, CategoryID),

    FOREIGN KEY (DealID)
        REFERENCES Deal(DealID),

    FOREIGN KEY (CategoryID)
        REFERENCES Category(CategoryID)
);

CREATE TABLE BusinessLocation (
    BusinessID INT,
    LocationID INT,

    PRIMARY KEY (BusinessID, LocationID),

    FOREIGN KEY (BusinessID)
        REFERENCES Business(BusinessID),

    FOREIGN KEY (LocationID)
        REFERENCES Location(LocationID)
);