-- ============================================================
-- DESTINATION DEALS — Sample Data
-- Updated: June 2026
-- Reflects full schema after migrations v1-v4
-- Newport RI focus with a few Providence RI + Boston MA entries
-- ============================================================

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

-- ── Categories ───────────────────────────────────────────────
INSERT INTO Category (CategoryName) VALUES
    ('Restaurant'),
    ('Retail'),
    ('Activity'),
    ('Family-Friendly');

-- ── Locations ────────────────────────────────────────────────
INSERT INTO Location (City, State, Description) VALUES
    ('Newport',      'RI', 'Historic coastal tourist destination'),
    ('Providence',   'RI', 'Capital city with restaurants and nightlife'),
    ('Narragansett', 'RI', 'Beach and surfing destination'),
    ('Westerly',     'RI', 'Family-friendly beach town'),
    ('Boston',       'MA', 'Major metropolitan tourist hub'),
    ('Mystic',       'CT', 'Historic maritime tourism town');

-- ── Businesses ───────────────────────────────────────────────
-- subscription_tier, is_verified, latitude, longitude,
-- outdoor_dining, live_music, waterfront, pet_friendly
INSERT INTO Business
    (Name, Address, Phone, Website,
     subscription_tier, is_verified,
     latitude, longitude,
     outdoor_dining, live_music, waterfront, pet_friendly)
VALUES

-- Newport Restaurants
('Caroline''s Oyster Bar',
 '345 Thames St', '4018472489', 'https://www.carolinesoysterbar.com',
 'Premium', TRUE, 41.4831, -71.3176, TRUE, TRUE, FALSE, FALSE),

('Fagooli''s Grille',
 '1 Sayers Wharf', '4018496664', 'https://www.fagoolis.com',
 'Premium', TRUE, 41.4878, -71.3243, TRUE, FALSE, TRUE, FALSE),

('Twist and Shout Cocktail Bar',
 '7 Bannister Wharf', '4018464388', 'https://www.twistandshout-newport.com',
 'Basic', TRUE, 41.4865, -71.3231, TRUE, FALSE, TRUE, TRUE),

('Up-a-Notch Kitchen',
 '677 Thames St', '4018463474', 'https://www.upanothcnewport.com',
 'Premium', TRUE, 41.4791, -71.3163, FALSE, TRUE, FALSE, FALSE),

('Fluke Wine Bar & Kitchen',
 '41 Bowen Wharf', '4018494004', 'https://www.flukewineandkitchen.com',
 'Basic', TRUE, 41.4863, -71.3229, FALSE, TRUE, FALSE, FALSE),

('The Blue Macaw',
 '348 Thames St', '4018477427', 'https://www.thebluemacaw.com',
 'Basic', TRUE, 41.4832, -71.3175, TRUE, TRUE, FALSE, FALSE),

('Ocean Breeze Cafe',
 '150 Broadway', '4018471122', 'https://www.oceanbreezenewport.com',
 'Basic', FALSE, 41.4888, -71.3144, TRUE, FALSE, FALSE, TRUE),

('Anchor & Vine Pub',
 '140 Thames St', '4018490111', 'https://www.anchorandvinepub.com',
 'Basic', TRUE, 41.4853, -71.3188, FALSE, TRUE, FALSE, FALSE),

('Casa del Sol',
 '19 Charles St', '4018495832', 'https://www.casadelsol-newport.com',
 'Basic', TRUE, 41.4842, -71.3171, TRUE, FALSE, FALSE, FALSE),

('Bella Napoli',
 '673 Thames St', '4018482077', 'https://www.bellanapoli-newport.com',
 'Basic', TRUE, 41.4789, -71.3162, FALSE, FALSE, FALSE, FALSE),

-- Newport Retail
('Thames Street Boutique',
 '15 Thames St', '4015551001', 'https://www.thamesboutique.com',
 'Basic', TRUE, 41.4855, -71.3193, FALSE, FALSE, FALSE, FALSE),

('Newport Vintage Market',
 '220 Bellevue Ave', '4018473345', 'https://www.newportvintagemkt.com',
 'Basic', TRUE, 41.4801, -71.3068, FALSE, FALSE, FALSE, FALSE),

('Elsas Gifts on Bowens Wharf',
 '5 Bowen Wharf', '4018476622', 'https://www.elsasgifts.com',
 'Basic', FALSE, 41.4866, -71.3232, FALSE, FALSE, TRUE, FALSE),

('Newport Surf Co.',
 '182 Thames St', '4018479933', 'https://www.newportsurfco.com',
 'Basic', TRUE, 41.4857, -71.3197, FALSE, FALSE, FALSE, FALSE),

-- Newport Activity
('Newport Sailing Adventures',
 '22 Bowen Wharf', '4015551002', 'https://www.newportsailing.com',
 'Premium', TRUE, 41.4868, -71.3234, FALSE, FALSE, TRUE, FALSE),

('Vintage Cruiseline Excursions',
 '1 Bannister Wharf', '4018470955', 'https://www.vintagecruiseline.com',
 'Premium', TRUE, 41.4864, -71.3230, FALSE, FALSE, TRUE, FALSE),

('Cliff Walk Tours',
 '175 Memorial Blvd', '4018471177', 'https://www.cliffwalktours.com',
 'Basic', TRUE, 41.4912, -71.3048, FALSE, FALSE, FALSE, TRUE),

('Nigel''s Star Gazing Tours',
 '35 East Bowery St', '4015552001', 'https://www.stargazewithnigel.com',
 'Basic', FALSE, 41.4923, -71.3041, FALSE, FALSE, FALSE, FALSE),

('Newport Kayak Center',
 '9 Waites Wharf', '4018453277', 'https://www.newportkayak.com',
 'Basic', TRUE, 41.4857, -71.3219, FALSE, FALSE, TRUE, TRUE),

('Aquidneck Island Bike Tours',
 '62 Broadway', '4018476688', 'https://www.aquidneckbiketours.com',
 'Basic', TRUE, 41.4889, -71.3141, FALSE, FALSE, FALSE, TRUE),

-- Newport Family-Friendly
('Family Fun Arcade',
 '10 Americas Cup Ave', '4015551003', 'https://www.familyfunarcade.com',
 'Basic', TRUE, 41.4868, -71.3131, FALSE, FALSE, FALSE, FALSE),

('Newport Heritage Center',
 '25 Young St', '4015552002', 'https://www.newportheritage.com',
 'Basic', TRUE, 41.4878, -71.3124, FALSE, FALSE, FALSE, FALSE),

('Fort Adams State Park',
 '90 Fort Adams Dr', '4018410707', 'https://www.fortadams.org',
 'Basic', TRUE, 41.4701, -71.3398, TRUE, FALSE, TRUE, TRUE),

('Shoreline Snack Shack',
 '175 Memorial Blvd', '4018477171', 'https://www.shorelinesnackshack.com',
 'Basic', TRUE, 41.4941, -71.2968, TRUE, FALSE, FALSE, TRUE),

-- Newport Multi / Other
('Cliff Walk Cafe',
 '50 Memorial Blvd', '4015551004', 'https://www.cliffwalkcafe.com',
 'Basic', FALSE, 41.4902, -71.3089, TRUE, FALSE, FALSE, FALSE),

('Seafood by the Sea',
 '100 Americas Cup Ave', '4015552003', 'https://www.seafoodbythesea.com',
 'Premium', TRUE, 41.4868, -71.3131, TRUE, FALSE, TRUE, FALSE),

('Andrew''s Burgers',
 '33 Howard St', '4015552004', 'https://www.andrewsburgers.com',
 'Basic', TRUE, 41.4812, -71.3198, FALSE, FALSE, FALSE, FALSE),

('Hillside Grille',
 '254 Thames St', '4018468768', 'https://www.hillsidegrillenewport.com',
 'Basic', TRUE, 41.4835, -71.3180, TRUE, TRUE, FALSE, FALSE),

('Bolt Coffee - Thames',
 '404 Thames St', '4018889999', 'https://www.boltcoffeenewport.com',
 'Basic', TRUE, 41.4821, -71.3170, FALSE, FALSE, FALSE, FALSE),

('Bolt Coffee - Broadway',
 '228 Broadway', '4015555552', 'https://www.boltcoffeenewport.com',
 'Basic', TRUE, 41.4888, -71.3148, FALSE, FALSE, FALSE, FALSE),

('Simple Merchant Coffee',
 '513 Broadway', '4018858855', 'https://www.simplemerchant.com',
 'Basic', TRUE, 41.4897, -71.3158, TRUE, FALSE, FALSE, TRUE),

('Senegal''s Raw Bar',
 '254 Thames St', '4018468768', 'https://www.senegalsrawbar.com',
 'Basic', TRUE, 41.4835, -71.3101, TRUE, FALSE, FALSE, FALSE),

-- Providence
('Maison Renard',
 '960 Hope St', '4014212485', 'https://www.maisonrenard.com',
 'Premium', TRUE, 41.8368, -71.3886, TRUE, FALSE, FALSE, FALSE),

('The Colony Bar',
 '122 Fountain St', '4012731116', 'https://www.thecolonybar.com',
 'Basic', TRUE, 41.8218, -71.4133, FALSE, TRUE, FALSE, FALSE),

-- Boston
('Faneuil Street Grille',
 '1 Faneuil Hall Marketplace', '6172271115', 'https://www.faneuilstreetgrille.com',
 'Basic', TRUE, 42.3600, -71.0560, FALSE, FALSE, FALSE, FALSE),

('Jimbabwe Lighthouse Tours',
 '1 Long Wharf', '6172272628', 'https://www.jimbabwetours.com',
 'Premium', TRUE, 42.3597, -71.0495, FALSE, FALSE, TRUE, FALSE);

-- ── Business Categories ───────────────────────────────────────
INSERT INTO BusinessCategory (BusinessID, CategoryID) VALUES
-- Newport Restaurants (cat 1)
(1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),
-- Newport Retail (cat 2)
(11,2),(12,2),(13,2),(14,2),
-- Newport Activity (cat 3)
(15,3),(16,3),(17,3),(18,3),(19,3),(20,3),
-- Newport Family-Friendly (cat 4)
(21,4),(22,4),(23,4),(24,4),
-- Newport Multi
(25,1),(25,4),   -- Cliff Walk Cafe: Restaurant + Family
(26,1),          -- Seafood by the Sea
(27,1),          -- Andrews Burgers
(28,1),          -- Cappys
(29,1),          -- Nitro Thames
(30,1),          -- Nitro Broadway
(31,1),          -- Simple Merchant
(32,1),          -- Benjamins
-- Providence
(33,1),          -- Chez Pascal
(34,1),          -- The Dean Bar
-- Boston
(35,1),          -- Quincy Market Grill
(36,3);          -- Boston Harbor Tours

-- ── Business Locations ────────────────────────────────────────
INSERT INTO BusinessLocation (BusinessID, LocationID) VALUES
-- All Newport businesses → LocationID 1
(1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),
(11,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),
(21,1),(22,1),(23,1),(24,1),(25,1),(26,1),(27,1),(28,1),(29,1),(30,1),
(31,1),(32,1),
-- Providence → LocationID 2
(33,2),(34,2),
-- Boston → LocationID 5
(35,5),(36,5);

-- ── Deals ─────────────────────────────────────────────────────
INSERT INTO Deal
    (BusinessID, Title, Description, DiscountType, DiscountValue, IsActive, startdate, enddate)
VALUES
-- Caroline''s Oyster Bar (1)
(1,  'Happy Hour',            '20% off all drinks 4-6pm',                    'Percent', 20,   TRUE,  NULL, NULL),
(1,  'Half Off Appetizers',   '50% off all appetizers Mon-Thu 2-4pm',        'Percent', 50,   TRUE,  NULL, NULL),

-- Fagooli''s Grille (2)
(2,  'Sunset Dinner Special', '$15 off any entree after 7pm',                'Flat',    15,   TRUE,  NULL, NULL),
(2,  'Lobster Roll Monday',   'Market price lobster rolls every Monday',      'Custom',  NULL, TRUE,  NULL, NULL),

-- Twist and Shout Cocktail Bar (3)
(3,  'Cocktail Hour Special',   '10% off brunch for parties of 4 or more',     'Percent', 10,   TRUE,  NULL, NULL),

-- Up-a-Notch Kitchen (4)
(4,  'Date Night Special',    '$20 off when you spend $80 or more',          'Flat',    20,   TRUE,  NULL, NULL),
(4,  'Tasting Menu Tuesday',  '15% off the full tasting menu on Tuesdays',   'Percent', 15,   TRUE,  NULL, NULL),

-- Fluke Wine Bar (5)
(5,  'Wine Wednesday',        '25% off all bottles every Wednesday',         'Percent', 25,   TRUE,  NULL, NULL),

-- The Blue Macaw (6)
(6,  'Live Music Happy Hour', 'BOGO cocktails during live music sets',        'BOGO',    NULL, TRUE,  NULL, NULL),

-- Ocean Breeze Cafe (7)
(7,  'Breakfast Combo',       '10% off any breakfast combo before 11am',     'Percent', 10,   TRUE,  NULL, NULL),

-- Anchor & Vine Pub (8)
(8,  'Pub Night Special',     '$5 off any burger and beer combo',            'Flat',    5,    TRUE,  NULL, NULL),
(8,  'Wing Wednesday',        'Half price wings every Wednesday night',       'Percent', 50,   TRUE,  NULL, NULL),

-- Casa del Sol (9)
(9,  'Taco Tuesday',          '$2 tacos all day every Tuesday',              'Flat',    2,    TRUE,  NULL, NULL),

-- Bella Napoli (10)
(10, 'Family Sunday Supper',  '15% off for tables of 6 or more on Sundays', 'Percent', 15,   TRUE,  NULL, NULL),

-- Thames Street Boutique (11)
(11, 'Buy One Get One',       'Buy one shirt get one 50% off',               'Percent', 50,   TRUE,  NULL, NULL),

-- Newport Vintage Market (12)
(12, 'Weekend Discount',      '10% off any single item every weekend',       'Percent', 10,   TRUE,  NULL, NULL),

-- Elsas Gifts on Bowens Wharf (13)
(13, 'Summer Clearance',      '20% off all sale items',                      'Percent', 20,   TRUE,  '2026-06-20', '2026-08-31'),

-- Newport Surf Co. (14)
(14, 'Rental Deal',           '$5 off any equipment rental on weekdays',     'Flat',    5,    TRUE,  NULL, NULL),

-- Newport Sailing Adventures (15)
(15, 'Sunset Cruise Special', '$15 off any sailing trip booking',            'Flat',    15,   TRUE,  NULL, NULL),
(15, 'Morning Sail Discount', '20% off morning departures before 10am',      'Percent', 20,   TRUE,  NULL, NULL),

-- Vintage Cruiseline Excursions (16)
(16, 'Sunset Cruise',         '$10 off per person on sunset cruise tickets', 'Flat',    10,   TRUE,  NULL, NULL),

-- Cliff Walk Tours (17)
(17, 'Group Tour Deal',       '15% off for groups of 8 or more',            'Percent', 15,   TRUE,  NULL, NULL),

-- Nigels Star Gazing (18)
(18, 'Evening Telescope Tour','25% off any evening stargazing tour',         'Percent', 25,   TRUE,  NULL, NULL),

-- Newport Kayak Center (19)
(19, 'Kayak Rental Special',  '$10 off 2-hour kayak rentals on weekdays',   'Flat',    10,   TRUE,  NULL, NULL),

-- Aquidneck Bike Tours (20)
(20, 'Bike Tour Bundle',      '$5 off per person for groups of 4 or more',  'Flat',    5,    TRUE,  NULL, NULL),

-- Family Fun Arcade (21)
(21, 'Family Game Night',     'Unlimited arcade play for $20 per person',    'Flat',    20,   TRUE,  NULL, NULL),

-- Newport Heritage Center (22)
(22, 'Museum Admission',      '$5 off general admission any day',            'Flat',    5,    TRUE,  NULL, NULL),

-- Fort Adams (23)
(23, 'Summer Festival Pass',  '20% off event tickets purchased in advance',  'Percent', 20,   TRUE,  '2026-07-01', '2026-08-31'),

-- Shoreline Snack Shack (24)
(24, 'Beach Day Combo',       'Free drink with any food order over $15',     'Custom',  NULL, TRUE,  NULL, NULL),

-- Cliff Walk Cafe (25)
(25, 'Breakfast Combo',       '10% off all breakfast combos',               'Percent', 10,   TRUE,  NULL, NULL),
(25, 'Kids Eat Free',         'One free kids meal per adult entree',         'Flat',    0,    TRUE,  NULL, NULL),

-- Seafood by the Sea (26)
(26, 'Lobster Roll Special',  '15% off lobster rolls every weekend',         'Percent', 15,   TRUE,  NULL, NULL),

-- Andrew''s Burgers (27)
(27, 'Burger Combo Deal',     'Free fries with any combo purchase',          'Flat',    0,    TRUE,  NULL, NULL),

-- Hillside Grille (28)
(28, 'Happy Hour Appetizers',     'Half off any appetizer with 1 well drink',    'Percent', 50,   TRUE,  NULL, NULL),

-- Bolt Coffee Thames (29)
(29, 'Morning Cold Brew Deal',  '$1 off any nitro cold brew before 10am',     'Flat',    1,    TRUE,  NULL, NULL),

-- Bolt Coffee Broadway (30)
(30, 'Morning Coffee Special', '$1 off any nitro drink before 10am',         'Flat',    1,    TRUE,  NULL, NULL),

-- Simple Merchant (31)
(31, 'Loyalty Stamp Card',    'Buy 9 coffees get the 10th free',             'Custom',  NULL, TRUE,  NULL, NULL),

-- Senegal''s Raw Bar (32)
(32, 'Senegal''s Raw Bar Hour',          '$1 oysters and clams 3-6pm daily',           'Custom',  NULL, TRUE,  NULL, NULL),

-- Maison Renard Providence (33)
(33, 'Pre-Theatre Menu',      '3-course dinner for $45 before 6pm',         'Flat',    15,   TRUE,  NULL, NULL),

-- The Colony Bar Providence (34)
(34, 'Happy Hour',            '2-for-1 craft cocktails every weekday',       'BOGO',    NULL, TRUE,  NULL, NULL),

-- Faneuil Street Grille Boston (35)
(35, 'Lunch Special',         '10% off any order over $20 at lunch',        'Percent', 10,   TRUE,  NULL, NULL),

-- Jimbabwe Lighthouse Tours Boston (36)
(36, 'Jimbabwe Sunset Tour',  '$12 off per person on the sunset cruise',    'Flat',    12,   TRUE,  NULL, NULL);

-- ── Deal Categories ───────────────────────────────────────────
-- Mapped exactly to the 42 deals inserted above
INSERT INTO DealCategory (DealID, CategoryID) VALUES
-- Midtown/Coastline Oyster Bar deals (1,2) → Restaurant
(1,1),(2,1),
-- The Mooring deals (3,4) → Restaurant
(3,1),(4,1),
-- Bannister Wharf deal (5) → Restaurant
(5,1),
-- Thames Street Kitchen deals (6,7) → Restaurant
(6,1),(7,1),
-- Fluke Wine Bar deal (8) → Restaurant
(8,1),
-- The Red Parrot deal (9) → Restaurant
(9,1),
-- Ocean Breeze Cafe deal (10) → Restaurant
(10,1),
-- Brick Alley Pub deals (11,12) → Restaurant
(11,1),(12,1),
-- Perro Salado deal (13) → Restaurant
(13,1),
-- Mama Luisa deal (14) → Restaurant
(14,1),
-- Thames Street Boutique deal (15) → Retail
(15,2),
-- Newport Vintage Market deal (16) → Retail
(16,2),
-- Bowen Wharf Gifts deal (17) → Retail
(17,2),
-- Newport Surf Co deal (18) → Retail
(18,2),
-- Newport Sailing Adventures deals (19,20) → Activity
(19,3),(20,3),
-- Classic Cruises deal (21) → Activity
(21,3),
-- Cliff Walk Tours deal (22) → Activity
(22,3),
-- Nigels Star Gazing deal (23) → Activity
(23,3),
-- Newport Kayak Center deal (24) → Activity
(24,3),
-- Aquidneck Bike Tours deal (25) → Activity
(25,3),
-- Family Fun Arcade deal (26) → Family-Friendly
(26,4),
-- Newport History Museum deal (27) → Family-Friendly
(27,4),
-- Fort Adams deal (28) → Family-Friendly
(28,4),
-- Easton Beach deal (29) → Family-Friendly
(29,4),
-- Cliff Walk Cafe deals (30,31) → Restaurant + Family-Friendly
(30,1),(31,1),(31,4),
-- Seafood by the Sea deal (32) → Restaurant
(32,1),
-- Andrews Burgers deal (33) → Restaurant
(33,1),
-- Hillside Grille deal (34) → Restaurant
(34,1),
-- Bolt Coffee Thames deal (35) → Restaurant
(35,1),
-- Bolt Coffee Broadway deal (36) → Restaurant
(36,1),
-- Simple Merchant deal (37) → Restaurant
(37,1),
-- Harbor Raw Bar deal (38) → Restaurant
(38,1),
-- Chez Pascal deal (39) → Restaurant
(39,1),
-- The Dean Bar deal (40) → Restaurant
(40,1),
-- Quincy Market deal (41) → Restaurant
(41,1),
-- Boston Harbor Tours deal (42) → Activity
(42,3);

-- ── Deal Schedules ────────────────────────────────────────────
INSERT INTO DealSchedule (DealID, DayOfWeek, StartTime, EndTime) VALUES
-- Deal 1: Happy Hour — Mon-Fri 4-6pm
(1,'Monday','16:00','18:00'),(1,'Tuesday','16:00','18:00'),
(1,'Wednesday','16:00','18:00'),(1,'Thursday','16:00','18:00'),
(1,'Friday','16:00','18:00'),
-- Deal 2: Half Off Apps — Mon-Thu 2-4pm
(2,'Monday','14:00','16:00'),(2,'Tuesday','14:00','16:00'),
(2,'Wednesday','14:00','16:00'),(2,'Thursday','14:00','16:00'),
-- Deal 3: Sunset Dinner — Everyday 7pm-close
(3,'Sunday','19:00','22:00'),(3,'Monday','19:00','22:00'),
(3,'Tuesday','19:00','22:00'),(3,'Wednesday','19:00','22:00'),
(3,'Thursday','19:00','22:00'),(3,'Friday','19:00','22:00'),
(3,'Saturday','19:00','22:00'),
-- Deal 4: Lobster Roll Monday
(4,'Monday','11:00','21:00'),
-- Deal 5: Weekend Brunch
(5,'Saturday','10:00','14:00'),(5,'Sunday','10:00','14:00'),
-- Deal 6: Date Night
(6,'Thursday','17:00','22:00'),(6,'Friday','17:00','22:00'),
(6,'Saturday','17:00','22:00'),
-- Deal 7: Tasting Tuesday
(7,'Tuesday','17:00','22:00'),
-- Deal 8: Wine Wednesday
(8,'Wednesday','17:00','22:00'),
-- Deal 9: Live Music Happy Hour
(9,'Friday','17:00','19:00'),(9,'Saturday','17:00','19:00'),
-- Deal 10: Breakfast Combo
(10,'Monday','07:00','11:00'),(10,'Tuesday','07:00','11:00'),
(10,'Wednesday','07:00','11:00'),(10,'Thursday','07:00','11:00'),
(10,'Friday','07:00','11:00'),(10,'Saturday','07:00','11:00'),
(10,'Sunday','07:00','11:00'),
-- Deal 11: Pub Night
(11,'Thursday','17:00','22:00'),(11,'Friday','17:00','22:00'),
-- Deal 12: Wing Wednesday
(12,'Wednesday','17:00','22:00'),
-- Deal 13: Taco Tuesday
(13,'Tuesday','11:00','21:00'),
-- Deal 14: Family Sunday Supper
(14,'Sunday','15:00','21:00'),
-- Deal 15: BOGO Shirt — Saturday
(15,'Saturday','10:00','18:00'),
-- Deal 16: Weekend Discount
(16,'Saturday','10:00','18:00'),(16,'Sunday','10:00','18:00'),
-- Deal 17: Summer Clearance — everyday
(17,'Monday','10:00','18:00'),(17,'Tuesday','10:00','18:00'),
(17,'Wednesday','10:00','18:00'),(17,'Thursday','10:00','18:00'),
(17,'Friday','10:00','18:00'),(17,'Saturday','10:00','18:00'),
(17,'Sunday','10:00','18:00'),
-- Deal 18: Rental Deal — weekdays
(18,'Monday','09:00','17:00'),(18,'Tuesday','09:00','17:00'),
(18,'Wednesday','09:00','17:00'),(18,'Thursday','09:00','17:00'),
(18,'Friday','09:00','17:00'),
-- Deal 19: Sunset Cruise
(19,'Sunday','17:00','20:00'),(19,'Wednesday','17:00','20:00'),
(19,'Friday','17:00','20:00'),
-- Deal 20: Morning Sail
(20,'Saturday','08:00','10:00'),(20,'Sunday','08:00','10:00'),
-- Deal 21: Sunset Cruise Classic
(21,'Friday','18:00','20:00'),(21,'Saturday','18:00','20:00'),
(21,'Sunday','18:00','20:00'),
-- Deal 22: Group Tour
(22,'Saturday','09:00','17:00'),(22,'Sunday','09:00','17:00'),
-- Deal 23: Evening Telescope
(23,'Saturday','20:00','23:00'),
-- Deal 24: Kayak Rental
(24,'Monday','09:00','17:00'),(24,'Tuesday','09:00','17:00'),
(24,'Wednesday','09:00','17:00'),(24,'Thursday','09:00','17:00'),
(24,'Friday','09:00','17:00'),
-- Deal 25: Bike Tour Bundle
(25,'Saturday','09:00','16:00'),(25,'Sunday','09:00','16:00'),
-- Deal 26: Family Game Night
(26,'Friday','18:00','22:00'),(26,'Saturday','18:00','22:00'),
-- Deal 27: Museum Admission
(27,'Monday','10:00','17:00'),(27,'Tuesday','10:00','17:00'),
(27,'Wednesday','10:00','17:00'),(27,'Thursday','10:00','17:00'),
(27,'Friday','10:00','17:00'),(27,'Saturday','10:00','17:00'),
(27,'Sunday','10:00','17:00'),
-- Deal 28: Fort Adams Festival
(28,'Saturday','10:00','18:00'),(28,'Sunday','10:00','18:00'),
-- Deal 29: Beach Day Combo
(29,'Saturday','10:00','18:00'),(29,'Sunday','10:00','18:00'),
-- Deal 30: Breakfast Combo Cliff Walk
(30,'Monday','07:00','11:00'),(30,'Tuesday','07:00','11:00'),
(30,'Wednesday','07:00','11:00'),(30,'Thursday','07:00','11:00'),
(30,'Friday','07:00','11:00'),(30,'Saturday','07:00','11:00'),
(30,'Sunday','07:00','11:00'),
-- Deal 31: Kids Eat Free
(31,'Sunday','12:00','20:00'),
-- Deal 32: Lobster Roll Special
(32,'Saturday','11:00','21:00'),(32,'Sunday','11:00','21:00'),
-- Deal 33: Burger Combo
(33,'Saturday','11:00','21:00'),
-- Deal 34: Appetizer Special
(34,'Monday','16:00','21:00'),(34,'Tuesday','16:00','21:00'),
(34,'Wednesday','16:00','21:00'),(34,'Thursday','16:00','21:00'),
(34,'Friday','16:00','21:00'),(34,'Saturday','16:00','21:00'),
(34,'Sunday','16:00','21:00'),
-- Deal 35: Nitro Thames
(35,'Monday','07:00','10:00'),(35,'Tuesday','07:00','10:00'),
(35,'Wednesday','07:00','10:00'),(35,'Thursday','07:00','10:00'),
(35,'Friday','07:00','10:00'),(35,'Saturday','07:00','10:00'),
(35,'Sunday','07:00','10:00'),
-- Deal 36: Nitro Broadway
(36,'Monday','07:00','10:00'),(36,'Tuesday','07:00','10:00'),
(36,'Wednesday','07:00','10:00'),(36,'Thursday','07:00','10:00'),
(36,'Friday','07:00','10:00'),(36,'Saturday','07:00','10:00'),
(36,'Sunday','07:00','10:00'),
-- Deal 37: Simple Merchant Loyalty
(37,'Monday','07:00','17:00'),(37,'Tuesday','07:00','17:00'),
(37,'Wednesday','07:00','17:00'),(37,'Thursday','07:00','17:00'),
(37,'Friday','07:00','17:00'),(37,'Saturday','08:00','17:00'),
(37,'Sunday','08:00','17:00'),
-- Deal 38: Buck-a-Shuck Benjamins
(38,'Sunday','15:00','18:00'),(38,'Monday','15:00','18:00'),
(38,'Tuesday','15:00','18:00'),(38,'Wednesday','15:00','18:00'),
(38,'Thursday','15:00','18:00'),(38,'Friday','15:00','18:00'),
(38,'Saturday','15:00','18:00'),
-- Deal 39: Chez Pascal Pre-Theatre
(39,'Thursday','17:00','18:00'),(39,'Friday','17:00','18:00'),
(39,'Saturday','17:00','18:00'),
-- Deal 40: Dean Bar Happy Hour
(40,'Monday','16:00','18:00'),(40,'Tuesday','16:00','18:00'),
(40,'Wednesday','16:00','18:00'),(40,'Thursday','16:00','18:00'),
(40,'Friday','16:00','18:00'),
-- Deal 41: Quincy Market Lunch
(41,'Monday','11:00','14:00'),(41,'Tuesday','11:00','14:00'),
(41,'Wednesday','11:00','14:00'),(41,'Thursday','11:00','14:00'),
(41,'Friday','11:00','14:00'),
-- Deal 42: Boston Harbor Sunset
(42,'Friday','18:00','20:00'),(42,'Saturday','18:00','20:00'),
(42,'Sunday','18:00','20:00');

-- ── Additional Businesses (37-41) ───────────────────────────
INSERT INTO Business
    (Name, Address, Phone, Website,
     subscription_tier, is_verified,
     latitude, longitude,
     outdoor_dining, live_music, waterfront, pet_friendly)
VALUES
('Wind Surf Newport',
 '3 Waites Wharf', '4018479922', 'https://www.windsurfnewport.com',
 'Basic', TRUE, 41.4856, -71.3218, FALSE, FALSE, TRUE, FALSE),

('Newport Nicknacks',
 '108 Thames St', '4018471234', 'https://www.newportnicknacks.com',
 'Basic', TRUE, 41.4851, -71.3191, FALSE, FALSE, FALSE, FALSE),

('Arden Luxury Clothing Line',
 '332 Thames St', '4018476655', 'https://www.ardenluxury.com',
 'Basic', TRUE, 41.4829, -71.3174, FALSE, FALSE, FALSE, FALSE),

('Mack''s Music Store',
 '174 Broadway', '4018473388', 'https://www.macksmusicnewport.com',
 'Basic', TRUE, 41.4884, -71.3146, FALSE, TRUE, FALSE, FALSE),

('Brian''s Duck Boat Tour',
 '1 State St', '6172291234', 'https://www.briansduckboat.com',
 'Basic', TRUE, 42.3588, -71.0577, FALSE, FALSE, TRUE, FALSE);

-- New business categories
INSERT INTO BusinessCategory (BusinessID, CategoryID) VALUES
(37, 3), (37, 4),   -- Wind Surf Newport → Activity + Family-Friendly
(38, 2),            -- Newport Nicknacks → Retail
(39, 2),            -- Arden Vintage → Retail
(40, 2),            -- Mack's Music → Retail
(41, 3), (41, 4);   -- Brian's Duck Boat → Activity + Family-Friendly

-- New business locations
INSERT INTO BusinessLocation (BusinessID, LocationID) VALUES
(37, 1),   -- Wind Surf → Newport
(38, 1),   -- Newport Nicknacks → Newport
(39, 1),   -- Arden Vintage → Newport
(40, 1),   -- Mack's Music → Newport
(41, 5);   -- Brian's Duck Boat → Boston

-- ── Additional Deals (43-49) ─────────────────────────────────
INSERT INTO Deal
    (BusinessID, Title, Description, DiscountType, DiscountValue, IsActive, startdate, enddate)
VALUES
-- Wind Surf Newport (37)
(37, 'Beginner Lesson Deal',
 '20% off your first windsurfing lesson',
 'Percent', 20, TRUE, NULL, NULL),

(37, 'Family Surf Package',
 '$25 off group lessons for 3 or more family members',
 'Flat', 25, TRUE, NULL, NULL),

-- Newport Nicknacks (38)
(38, 'Buy 2 Get 1 Free',
 'Buy any two items and get the third of equal or lesser value free',
 'BOGO', NULL, TRUE, NULL, NULL),

-- Arden Luxury Clothing Line (39)
(39, 'Luxury Friday',
 '15% off all purchases every Friday',
 'Percent', 15, TRUE, NULL, NULL),

(39, 'Summer Luxury Sale',
 '20% off all summer luxury items',
 'Percent', 20, TRUE, '2026-06-21', '2026-08-31'),

-- Mack''s Music Store (40)
(40, 'String Section Special',
 '10% off all string instruments and accessories',
 'Percent', 10, TRUE, NULL, NULL),

-- Brian''s Duck Boat Tour (41)
(41, 'Family Duck Boat Deal',
 '$8 off per person for families of 4 or more',
 'Flat', 8, TRUE, NULL, NULL);

-- New deal categories
INSERT INTO DealCategory (DealID, CategoryID) VALUES
(43, 3), (43, 4),   -- Beginner Lesson → Activity + Family-Friendly
(44, 3), (44, 4),   -- Family Surf Package → Activity + Family-Friendly
(45, 2),            -- Buy 2 Get 1 → Retail
(46, 2),            -- Vintage Friday → Retail
(47, 2),            -- Summer Vintage Sale → Retail
(48, 2),            -- String Section → Retail
(49, 3), (49, 4);   -- Duck Boat → Activity + Family-Friendly

-- New deal schedules
INSERT INTO DealSchedule (DealID, DayOfWeek, StartTime, EndTime) VALUES
-- Deal 43: Beginner Lesson — weekends
(43,'Saturday','09:00','17:00'),(43,'Sunday','09:00','17:00'),
-- Deal 44: Family Surf Package — weekends
(44,'Saturday','09:00','17:00'),(44,'Sunday','09:00','17:00'),
-- Deal 45: Buy 2 Get 1 — everyday
(45,'Monday','10:00','18:00'),(45,'Tuesday','10:00','18:00'),
(45,'Wednesday','10:00','18:00'),(45,'Thursday','10:00','18:00'),
(45,'Friday','10:00','18:00'),(45,'Saturday','10:00','18:00'),
(45,'Sunday','10:00','18:00'),
-- Deal 46: Vintage Friday
(46,'Friday','11:00','18:00'),
-- Deal 47: Summer Vintage Sale — everyday
(47,'Monday','11:00','18:00'),(47,'Tuesday','11:00','18:00'),
(47,'Wednesday','11:00','18:00'),(47,'Thursday','11:00','18:00'),
(47,'Friday','11:00','18:00'),(47,'Saturday','11:00','18:00'),
(47,'Sunday','11:00','18:00'),
-- Deal 48: String Section Special — everyday
(48,'Monday','10:00','18:00'),(48,'Tuesday','10:00','18:00'),
(48,'Wednesday','10:00','18:00'),(48,'Thursday','10:00','18:00'),
(48,'Friday','10:00','18:00'),(48,'Saturday','10:00','18:00'),
(48,'Sunday','10:00','18:00'),
-- Deal 49: Duck Boat — everyday
(49,'Monday','09:00','17:00'),(49,'Tuesday','09:00','17:00'),
(49,'Wednesday','09:00','17:00'),(49,'Thursday','09:00','17:00'),
(49,'Friday','09:00','17:00'),(49,'Saturday','09:00','17:00'),
(49,'Sunday','09:00','17:00');