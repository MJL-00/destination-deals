-- ============================================
-- SAMPLE DATA
-- ============================================

-- Categories

INSERT INTO Category (CategoryName)
VALUES
('Restaurant'),
('Retail'),
('Activity'),
('Family-Friendly');

------------------------------------------------

-- Locations

INSERT INTO Location (City, State, Description)
VALUES
('Newport', 'RI', 'Historic coastal tourist destination'),
('Providence', 'RI', 'Capital city with restaurants and nightlife'),
('Narragansett', 'RI', 'Beach and surfing destination'),
('Westerly', 'RI', 'Family-friendly beach town'),
('Boston', 'MA', 'Major metropolitan tourist hub'),
('Mystic', 'CT', 'Historic maritime tourism town');

------------------------------------------------

-- Businesses

INSERT INTO Business
(Name, Address, City, State, ZipCode, Phone, Website)
VALUES

('Ocean View Restaurant',
'25 Thames St',
'Newport',
'RI',
'02840',
'4015551000',
'www.oceanviewrestaurant.com'),

('Thames Street Boutique',
'15 Thames St',
'Newport',
'RI',
'02840',
'4015551001',
'www.thamesboutique.com'),

('Newport Sailing Adventures',
'22 Bowen Wharf',
'Newport',
'RI',
'02840',
'4015551002',
'www.newportsailing.com'),

('Family Fun Arcade',
'10 Americas Cup Ave',
'Newport',
'RI',
'02840',
'4015551003',
'www.familyfunarcade.com'),

('Cliff Walk Cafe',
'50 Memorial Blvd',
'Newport',
'RI',
'02840',
'4015551004',
'www.cliffwalkcafe.com'),

('Nigels Star Gazing Tours',
'195 East Boweryl St',
'Newport',
'RI',
'02840',
'4015552001',
'www.stargazewithnigel.com'),

('Newport History Museum',
'555 Young St',
'Newport',
'RI',
'02840',
'4015552002',
'www.newporthistorymuseum.com'),

('Seafood by the Sea',
'1000 America''s Cup Ave',
'Newport',
'RI',
'02840',
'4015552003',
'www.seafoodbythesea.com'),

('Andrews Burgers',
'1033 Howard St',
'Newport',
'RI',
'02840',
'4015552004',
'www.andrewsburgers.com');

------------------------------------------------

-- Business Categories

INSERT INTO BusinessCategory
(BusinessID, CategoryID)
VALUES

(1,1),

(2,2),

(3,3),

(4,4),

(5,1),
(5,4),

(6,3),

(7,4),

(8,1),

(9,1);

------------------------------------------------

-- Deals

INSERT INTO Deal
(BusinessID, Title, Description, DiscountType, DiscountValue, IsActive)
VALUES

(1,'Happy Hour','20% off drinks','Percent',20,TRUE),

(2,'Buy One Get One','Buy one shirt get one 50% off','Percent',50,TRUE),

(3,'Sunset Cruise Special','$15 off sailing trip','Flat',15,TRUE),

(4,'Family Game Night','Unlimited arcade play for $20','Flat',20,TRUE),

(5,'Breakfast Combo','10% off breakfast combos','Percent',10,TRUE),

(5,'Kids Eat Free','One free kids meal per adult entree','Flat',0,TRUE),

(6,'Evening Telescope Tour','25% off evening tour','Percent',25,TRUE),

(7,'Museum Admission Discount','$5 off admission','Flat',5,TRUE),

(8,'Lobster Roll Special','15% off lobster rolls','Percent',15,TRUE),

(9,'Burger Combo Deal','Free fries with combo purchase','Flat',0,TRUE);

------------------------------------------------

-- Deal Categories

INSERT INTO DealCategory
(DealID, CategoryID)
VALUES

(1,1),

(2,2),

(3,3),

(4,4),

(5,1),

(6,1),
(6,4),

(7,3),

(8,4),

(9,1),

(10,1);

------------------------------------------------

-- Deal Schedules

INSERT INTO DealSchedule
(DealID, DayOfWeek, StartTime, EndTime)
VALUES

(1,'Friday','16:00','18:00'),

(2,'Saturday','10:00','18:00'),

(3,'Sunday','17:00','20:00'),

(4,'Friday','18:00','22:00'),

(5,'Saturday','08:00','12:00'),

(6,'Sunday','12:00','20:00'),

(7,'Saturday','19:00','22:00'),

(8,'Sunday','10:00','17:00'),

(9,'Friday','11:00','20:00'),

(10,'Saturday','11:00','21:00');

------------------------------------------------

-- Business Locations

INSERT INTO BusinessLocation
(BusinessID, LocationID)
VALUES

(1,1),
(2,1),
(3,1),
(4,1),
(5,1),
(6,1),
(7,1),
(8,1),
(9,1);