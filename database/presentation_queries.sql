-- ============================================
-- PRESENTATION QUERY #1
-- Sunday Deals
-- ============================================

SELECT
    Business.Name,
    Deal.Title,
    DealSchedule.DayOfWeek,
    DealSchedule.StartTime,
    DealSchedule.EndTime
FROM Deal
JOIN DealSchedule
ON Deal.DealID = DealSchedule.DealID
JOIN Business
ON Deal.BusinessID = Business.BusinessID
WHERE DealSchedule.DayOfWeek = 'Sunday';

------------------------------------------------

-- PRESENTATION QUERY #2
-- Business, Deal, Description, Day
------------------------------------------------

SELECT
    Business.Name,
    Deal.Title,
    Deal.Description,
    DealSchedule.DayOfWeek
FROM Business
JOIN Deal
ON Business.BusinessID = Deal.BusinessID
JOIN DealSchedule
ON Deal.DealID = DealSchedule.DealID;

------------------------------------------------

-- PRESENTATION QUERY #3
-- Family-Friendly Deals
------------------------------------------------

SELECT
    Business.Name,
    Deal.Title,
    Category.CategoryName
FROM DealCategory
JOIN Deal
ON DealCategory.DealID = Deal.DealID
JOIN Business
ON Deal.BusinessID = Business.BusinessID
JOIN Category
ON DealCategory.CategoryID = Category.CategoryID
WHERE Category.CategoryName = 'Family-Friendly';

------------------------------------------------

-- PRESENTATION QUERY #4
-- Businesses With Multiple Deals
------------------------------------------------

SELECT
    Business.Name,
    COUNT(Deal.DealID) AS NumberOfDeals
FROM Business
JOIN Deal
ON Business.BusinessID = Deal.BusinessID
GROUP BY Business.Name
HAVING COUNT(Deal.DealID) > 1;

------------------------------------------------

-- PRESENTATION QUERY #5
-- Newport Deals
------------------------------------------------

SELECT
    Business.Name,
    Deal.Title,
    Deal.Description,
    Location.City
FROM Business
JOIN BusinessLocation
ON Business.BusinessID = BusinessLocation.BusinessID
JOIN Location
ON BusinessLocation.LocationID = Location.LocationID
JOIN Deal
ON Business.BusinessID = Deal.BusinessID
WHERE Location.City = 'Newport';