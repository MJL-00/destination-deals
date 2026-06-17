-- ============================================
-- DESTINATION DEALS — SAMPLE DATA
-- Updated: June 2026
-- Reflects schema after migration v1 + v2
-- ============================================

-- Clear existing data in dependency order
TRUNCATE TABLE
    DealSchedule,
    DealCategory,
    Deal,
    BusinessCategory,
    BusinessLocation,
    Business,
    Location,
    Category
RESTART IDENTITY CASCADE;

------------------------------------------------
-- Categories
------------------------------------------------

INSERT INTO Category (CategoryName)
VALUES
    ('Restaurant'),
    ('Retail'),
    ('Activity'),
    ('Family-Friendly');

------------------------------------------------
-- Locations
------------------------------------------------

INSERT INTO Location (City, State, Description)
VALUES
    ('Newport',      'RI', 'Historic coastal tourist destination'),
    ('Providence',   'RI', 'Capital city with restaurants and nightlife'),
    ('Narragansett', 'RI', 'Beach and surfing destination'),
    ('Westerly',     'RI', 'Family-friendly beach town'),
    ('Boston',       'MA', 'Major metropolitan tourist hub'),
    ('Mystic',       'CT', 'Historic maritime tourism town');

------------------------------------------------
-- Businesses
-- Removed: City, State, ZipCode (dropped in migration v2)
-- Added:   subscription_tier, is_verified
------------------------------------------------

INSERT INTO Business
    (Name, Address, Phone, Website, subscription_tier, is_verified)
VALUES
    ('Ocean View Restaurant',
     '25 Thames St',        '4015551000', 'https://www.oceanviewrestaurant.com',  'Premium', TRUE),

    ('Thames Street Boutique',
     '15 Thames St',        '4015551001', 'https://www.thamesboutique.com',       'Basic',   TRUE),

    ('Newport Sailing Adventures',
     '22 Bowen Wharf',      '4015551002', 'https://www.newportsailing.com',       'Premium', TRUE),

    ('Family Fun Arcade',
     '10 Americas Cup Ave', '4015551003', 'https://www.familyfunarcade.com',      'Basic',   TRUE),

    ('Cliff Walk Cafe',
     '50 Memorial Blvd',    '4015551004', 'https://www.cliffwalkcafe.com',        'Basic',   FALSE),

    ('Nigels Star Gazing Tours',
     '35 East Bowery St',  '4015552001', 'https://www.stargazewithnigel.com',    'Basic',   FALSE),

    ('Newport History Museum',
     '25 Young St',        '4015552002', 'https://www.newporthistorymuseum.com', 'Basic',   TRUE),

    ('Seafood by the Sea',
     '100 Americas Cup Ave','4015552003', 'https://www.seafoodbythesea.com',     'Premium', TRUE),

    ('Andrews Burgers',
     '33 Howard St',      '4015552004', 'https://www.andrewsburgers.com',       'Basic',   TRUE);

------------------------------------------------
-- Business Categories
------------------------------------------------

INSERT INTO BusinessCategory (BusinessID, CategoryID)
VALUES
    (1, 1),        -- Ocean View Restaurant       → Restaurant
    (2, 2),        -- Thames Street Boutique      → Retail
    (3, 3),        -- Newport Sailing Adventures  → Activity
    (4, 4),        -- Family Fun Arcade           → Family-Friendly
    (5, 1),        -- Cliff Walk Cafe             → Restaurant
    (5, 4),        --                             → Family-Friendly
    (6, 3),        -- Nigels Star Gazing Tours    → Activity
    (7, 4),        -- Newport History Museum      → Family-Friendly
    (8, 1),        -- Seafood by the Sea          → Restaurant
    (9, 1);        -- Andrews Burgers             → Restaurant

------------------------------------------------
-- Business Locations (all Newport for now)
------------------------------------------------

INSERT INTO BusinessLocation (BusinessID, LocationID)
VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 1),
    (6, 1),
    (7, 1),
    (8, 1),
    (9, 1);

------------------------------------------------
-- Deals
-- Note: click_count, redemption_count default to 0
--       created_at, updated_at default to NOW()
------------------------------------------------

INSERT INTO Deal
    (BusinessID, Title, Description, DiscountType, DiscountValue, IsActive)
VALUES
    (1, 'Happy Hour',
     '20% off all drinks at the bar',
     'Percent', 20, TRUE),

    (2, 'Buy One Get One',
     'Buy one shirt, get one 50% off',
     'Percent', 50, TRUE),

    (3, 'Sunset Cruise Special',
     '$15 off any sailing trip booking',
     'Flat', 15, TRUE),

    (4, 'Family Game Night',
     'Unlimited arcade play for $20 per person',
     'Flat', 20, TRUE),

    (5, 'Breakfast Combo',
     '10% off all breakfast combos',
     'Percent', 10, TRUE),

    (5, 'Kids Eat Free',
     'One free kids meal per adult entree purchased',
     'Flat', 0, TRUE),

    (6, 'Evening Telescope Tour',
     '25% off any evening stargazing tour',
     'Percent', 25, TRUE),

    (7, 'Museum Admission Discount',
     '$5 off general admission',
     'Flat', 5, TRUE),

    (8, 'Lobster Roll Special',
     '15% off lobster rolls every weekend',
     'Percent', 15, TRUE),

    (9, 'Burger Combo Deal',
     'Free fries with any combo purchase',
     'Flat', 0, TRUE);

------------------------------------------------
-- Deal Categories
------------------------------------------------

INSERT INTO DealCategory (DealID, CategoryID)
VALUES
    (1,  1),       -- Happy Hour              → Restaurant
    (2,  2),       -- BOGO Shirt              → Retail
    (3,  3),       -- Sunset Cruise           → Activity
    (4,  4),       -- Family Game Night       → Family-Friendly
    (5,  1),       -- Breakfast Combo         → Restaurant
    (6,  1),       -- Kids Eat Free           → Restaurant
    (6,  4),       --                         → Family-Friendly
    (7,  3),       -- Telescope Tour          → Activity
    (8,  4),       -- Museum Discount         → Family-Friendly
    (9,  1),       -- Lobster Roll            → Restaurant
    (10, 1);       -- Burger Combo            → Restaurant

------------------------------------------------
-- Deal Schedules
------------------------------------------------

INSERT INTO DealSchedule (DealID, DayOfWeek, StartTime, EndTime)
VALUES
    (1,  'Friday',   '16:00', '18:00'),   -- Happy Hour
    (2,  'Saturday', '10:00', '18:00'),   -- BOGO Shirt
    (3,  'Sunday',   '17:00', '20:00'),   -- Sunset Cruise
    (4,  'Friday',   '18:00', '22:00'),   -- Family Game Night
    (5,  'Saturday', '08:00', '12:00'),   -- Breakfast Combo
    (6,  'Sunday',   '12:00', '20:00'),   -- Kids Eat Free
    (7,  'Saturday', '19:00', '22:00'),   -- Telescope Tour
    (8,  'Sunday',   '10:00', '17:00'),   -- Museum Discount
    (9,  'Friday',   '11:00', '20:00'),   -- Lobster Roll
    (10, 'Saturday', '11:00', '21:00');   -- Burger Combo

