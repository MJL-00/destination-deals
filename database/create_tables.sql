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
    BusinessID SERIAL PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    Phone VARCHAR(20),
    Website VARCHAR(255)
);

CREATE TABLE Deal (
    DealID SERIAL PRIMARY KEY,
    BusinessID INT NOT NULL,
    Title VARCHAR(150) NOT NULL,
    Description VARCHAR(255),
    DiscountType VARCHAR(50),
    DiscountValue DECIMAL(10,2),
    IsActive BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (BusinessID)
        REFERENCES Business(BusinessID)
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