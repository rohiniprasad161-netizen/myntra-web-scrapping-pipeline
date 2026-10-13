====================================================================
PROJECT: E-COMMERCE PRICE & DISCOUNT INTELLIGENCE TRACKER
====================================================================

[1] BUSINESS PROBLEM SOLVED:
In highly competitive e-commerce markets, brands constantly alter discounts to steal customer market share. This project automates competitor tracking on Myntra's mobile accessories marketplace to give business owners daily pricing intelligence.

[2] DATA PIPELINE ARCHITECTURE:
- Data Extraction: Python, Selenium, & BeautifulSoup (Extracted 5,000+ live records).
- Data Engineering: Pandas (Filtered junk accessories, handled missing metrics, kept 3,747 valid rows).
- Database Management: Structured and uploaded optimized data into MySQL Server.
- Business Intelligence: Power BI Desktop utilizing Advanced DAX formulas.

[3] CORE ADVANCED DATA RE-ENGINEERING (DAX Columns):
- Selling_Price: Created dynamic transaction price using (Original_MRP - Discount_Price).
- Price_Segment: Segmented inventory into Budget (Under 500), Mid-Range (500-1500), and Premium (Above 1500).
- Accessory_Type: Text mapping to dynamically categorize into "Back Case" or "Mobile Cover".
- Rating_Group: Converted decimal ratings into qualitative buckets (Excellent, Good, Average, Poor).

[4] KEY STRATEGIC INSIGHTS GENERATED FOR BUSINESSES:
- Aggressive Sellers: Brands like Treemoda and Nu Republic lead market aggression with average discounts scaling past 80%.
- Stock Inventory Bias: 63.94% of live inventory consists of Premium items (Above ₹1,500), suggesting massive profit-margin potential for new low-to-mid range sellers.
- Quality vs Pricing: Heavy discounts don't always protect poor products. Dynamic filters instantly isolate low-rated clearance items.
====================================================================