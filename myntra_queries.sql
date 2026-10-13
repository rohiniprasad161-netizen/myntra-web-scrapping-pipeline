-- ====================================================================
-- BUSINESS INTELLIGENCE SQL QUERIES FOR MYNTRA ACCESSORIES DATA
-- ====================================================================

-- 1. Brand-wise Average Discount (Market Penetration Analysis)
-- Helps the client see which competitor is pricing most aggressively.
SELECT 
    Brand, 
    COUNT(*) AS Total_Products,
    ROUND(AVG(Discount_Percentage), 2) AS Avg_Discount_Pct
FROM myntra_phones
GROUP BY Brand
ORDER BY Avg_Discount_Pct DESC;

-- 2. Premium vs Budget Inventory Segmentation
-- Helps the business understand stock layout according to customer budget.
SELECT 
    CASE 
        WHEN (Original_MRP - Discount_Price) < 500 THEN 'Budget (Under 500)'
        WHEN (Original_MRP - Discount_Price) BETWEEN 500 AND 1500 THEN 'Mid-Range (500-1500)'
        ELSE 'Premium (Above 1500)'
    END AS Price_Segment,
    COUNT(*) AS Total_Count,
    ROUND(AVG(Rating_Stars), 2) AS Avg_Rating
FROM myntra_phones
GROUP BY Price_Segment
ORDER BY Total_Count DESC;

-- 3. High-Volume Red Flag Items (High Reviews, Bad Ratings)
-- Isolates poor quality items that are generating high complaints.
SELECT 
    Brand, Product_Name, Rating_Stars, Rating_Count
FROM myntra_phones
WHERE Rating_Stars < 3.5 AND Rating_Count > 50
ORDER BY Rating_Count DESC;

-- 4. Product Sub-Category Split (Covers vs Back Cases)
-- Analyzes which specific accessory type rules the inventory.
SELECT 
    CASE WHEN Product_Name LIKE '%Back%' THEN 'Back Case' ELSE 'Mobile Cover' END AS Accessory_Type,
    COUNT(*) AS Total_Count,
    ROUND(AVG(Discount_Percentage), 2) AS Avg_Discount,
    ROUND(AVG(Original_MRP - Discount_Price), 2) AS Avg_Price
FROM myntra_phones
GROUP BY Accessory_Type;

-- 5. Advance Window Function: Top 2 Best-Rated Covers per Brand
-- Used to pull star products for the home-screen promotion.
WITH RankedCovers AS (
    SELECT Brand, Product_Name, Rating_Stars, Rating_Count,
    ROW_NUMBER() OVER(PARTITION BY Brand ORDER BY Rating_Stars DESC, Rating_Count DESC) as rating_rank
    FROM myntra_phones
    WHERE Rating_Stars IS NOT NULL AND Rating_Count > 0
)
SELECT * FROM RankedCovers WHERE rating_rank <= 2;


-- 6. Discount Outliers (Kaun se products average se 25% zyada discount de rahe hain?)
-- Clearance sale ya stock nikalne wale products ko identify karne ke liye.
SELECT 
    Brand, 
    Product_Name, 
    Discount_Percentage,
    (Original_MRP - Discount_Price) AS Selling_Price
FROM myntra_phones
WHERE Discount_Percentage > (SELECT AVG(Discount_Percentage) + 25 FROM myntra_phones)
ORDER BY Discount_Percentage DESC;

-- 7. Ecosystem Analysis (Apple vs Samsung vs Android Market Share)
-- Company ko yeh batata hai ki kis phone brand ke users ke liye sabse zyada inventory hai.
SELECT 
    CASE 
        WHEN Product_Name LIKE '%iPhone%' OR Product_Name LIKE '%Apple%' THEN 'Apple Ecosystem'
        WHEN Product_Name LIKE '%Samsung%' OR Product_Name LIKE '%Galaxy%' THEN 'Samsung Ecosystem'
        WHEN Product_Name LIKE '%OnePlus%' THEN 'OnePlus Ecosystem'
        ELSE 'Other Brands / Universal'
    END AS Device_Compatibility,
    COUNT(*) AS Total_Covers,
    ROUND(AVG(Original_MRP - Discount_Price), 2) AS Avg_Selling_Price
FROM myntra_phones
GROUP BY Device_Compatibility
ORDER BY Total_Covers DESC;

-- 8. Customer Trust vs Price Elasticity (Weighted Rating Score)
-- Sirf rating dekhna galat hai (5 star agar 1 review hai toh bekar hai). 
-- Yeh formula Rating Stars aur Volume of Reviews dono ko milakar ek 'Trust Score' banata hai.
SELECT 
    Brand,
    Product_Name,
    Rating_Stars,
    Rating_Count,
    ROUND((Rating_Stars * 0.7) + ((Rating_Count / (SELECT MAX(Rating_Count) FROM myntra_phones)) * 3.0), 2) AS Customer_Trust_Score
FROM myntra_phones
WHERE Rating_Count > 10
ORDER BY Customer_Trust_Score DESC
LIMIT 10;

-- 9. Top Revenue-Generating Potential Inventory (MRP Tier Analysis)
-- Isse pata chalta hai ki kis brand ke paas high-value stock sabse zyada hai jahan profit badh sakta hai.
SELECT 
    Brand,
    COUNT(*) AS Product_Count,
    SUM(Original_MRP) AS Total_MRP_Value,
    ROUND(AVG(Original_MRP), 2) AS Avg_Base_MRP
FROM myntra_phones
GROUP BY Brand
HAVING Product_Count > 10
ORDER BY Total_MRP_Value DESC;

-- 10. Blank/Null Rating Optimization (Red Flag Data Quality Check)
-- E-commerce operations team ko un products ki list deta hai jinki rating abhi tak missing hai ya update nahi hui hai.
SELECT 
    Brand, 
    COUNT(*) AS Total_Products,
    SUM(CASE WHEN Rating_Stars IS NULL OR Rating_Stars = 0 THEN 1 ELSE 0 END) AS Unrated_Products_Count,
    ROUND((SUM(CASE WHEN Rating_Stars IS NULL OR Rating_Stars = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) AS Unrated_Percentage
FROM myntra_phones
GROUP BY Brand
ORDER BY Unrated_Percentage DESC;