# Blinkit_Analysis
End to End Project on creating Power BI dashboard analyzing Blinkit’s sales performance, item categories, and outlet trends across tiers and time.

# 🛒 Blinkit Sales Performance Dashboard
This Power BI dashboard visualizes the sales performance and product distribution of Blinkit – India’s last-minute grocery delivery app. It is designed to provide actionable insights into total sales, item distribution, outlet performance, and customer ratings across various outlet types and regions.

Click on the URL to view the dashboard
##### Dashboard : https://app.powerbi.com/view?r=eyJrIjoiNTZlYTZhYjYtNDc5My00OTMyLWEzMmItYzJiMjZhNmNmNGU5IiwidCI6IjVlMWVlNzI5LWI1M2MtNDJmMS05NzU4LTNjOGFkYWZlMTEwMCJ9

## 📊 Key Metrics Tracked:
Total Sales: $1.20M

Average Sales per Product: $141

Total Number of Items: 8,523

Average Ratings: 3.9 / 5

## 📌 Key Insights:
### 🔹 Item Analysis:
Top-selling item categories:

Fruits and Vegetables ($0.18M)

Snack Foods ($0.18M)

Household Products ($0.14M)

Lowest-selling item: Seafood ($0.01M)

### 🔹 Fat Content Distribution:
Regular items contribute the most to sales: $776.32K

Low Fat items: $425.36K

### 🔹 Outlet Type Performance:
Outlet Type	         Total Sales	Items	Avg Sales	Avg Rating
Supermarket Type1	 $787.55K	    5,577	$141	    4.0
Grocery Store	     $151.94K	    1,083	$140	    4.0
Supermarket Type3	 $130.71K	    935	    $140	    4.0
Supermarket Type2	 $131.48K	    928	    $142	    4.0

### 🔹 Location & Tier-wise Insights:
Tier 3 cities have the highest contribution in sales: $472.13K

Followed by Tier 2 ($393.15K) and Tier 1 ($336.40K)

### 🔹 Outlet Size Performance:
Medium-sized outlets outperform others with $507.90K in sales.

High-size outlets contribute $444.79K and small-size $248.99K.

### 🔹 Establishment Year Trend:
Peak performance year: 2018 with $205K in sales.

Sales fluctuated post-2018, with a dip in 2020 and a small recovery in 2022.

## 🛠️ Tools Used:
Power BI Desktop – For data visualization and dashboard creation.

DAX – To compute key performance metrics.

Data cleaning & transformation – Performed using Power Query Editor.

## 📈 Future Enhancements:
Add slicers for time-based filtering (monthly/quarterly sales).

Drill-through pages for item-level performance.

Integrate customer feedback or review sentiment if data is available.

# SQL QUERY ON BLINKIT ANALYSIS

**BLINK IT Database Project**

**View all data**
```sql
SELECT * FROM Blinkit_Data;
```
**DATA CLEANING: Standardize 'item_fat_content'**
```sql
UPDATE Blinkit_Data
SET item_fat_content = 
  CASE
    WHEN item_fat_content IN ('low fat', 'LF') THEN 'Low Fat' 
    WHEN item_fat_content = 'reg' THEN 'Regular'
    ELSE item_fat_content 
  END;
```
**Check distinct fat content values**
```sql
SELECT DISTINCT item_fat_content FROM Blinkit_Data;
```
**KPI METRICS**
**Total Sales**
```sql
SELECT CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales FROM Blinkit_Data;
```
**Average Sales**
```sql
SELECT CAST(AVG(sales) AS DECIMAL(10,2)) AS average_sales FROM Blinkit_Data;
```
**Number of Items**
```sql
SELECT COUNT(*) AS item_number FROM Blinkit_Data;
```
**Average Rating**
```sql
SELECT CAST(AVG(rating) AS DECIMAL(10,2)) AS avg_rating FROM Blinkit_Data;
```
**BUSINESS ANALYSIS**

**Total Sales by Fat Content**
```sql
SELECT item_fat_content,
       CONCAT(CAST(SUM(sales)/1000 AS DECIMAL(10,2)), ' K') AS total_sales_thousands,
       CAST(AVG(sales) AS DECIMAL(10,2)) AS average_sales,
       COUNT(*) AS item_number,
       CAST(AVG(rating) AS DECIMAL(10,2)) AS avg_rating
FROM Blinkit_Data
GROUP BY item_fat_content
ORDER BY total_sales_thousands DESC;
```
**Total Sales by Item Type**
```sql
SELECT item_type,
       CONCAT(CAST(SUM(sales)/1000 AS DECIMAL(10,2)), ' K') AS total_sales_thousands,
       CAST(AVG(sales) AS DECIMAL(10,2)) AS avg_sales,
       COUNT(*) AS item_numbers,
       CAST(AVG(rating) AS DECIMAL(10,2)) AS avg_rating
FROM Blinkit_Data
GROUP BY item_type
ORDER BY total_sales_thousands DESC;
```
**Total Sales by Outlet Location and Fat Content**
```sql
SELECT outlet_location_type, item_fat_content,
       CONCAT(CAST(SUM(sales)/1000 AS DECIMAL(10,2)), ' K') AS total_sales
FROM Blinkit_Data
GROUP BY outlet_location_type, item_fat_content
ORDER BY total_sales DESC;
```
**Pivot: Total Sales by Outlet Location and Fat Content**
```sql
SELECT outlet_location_type,
       [Low Fat] AS low_fat_sales,
       [Regular] AS regular_sales
FROM (
  SELECT outlet_location_type, item_fat_content,
         CAST(SUM(sales)/1000 AS DECIMAL(10,2)) AS total_sales
  FROM Blinkit_Data
  GROUP BY outlet_location_type, item_fat_content
) AS SourceTable
PIVOT (
  SUM(total_sales)
  FOR item_fat_content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY outlet_location_type;
```
**Pivot: Average Sales by Outlet Location and Fat Content**
```sql
SELECT outlet_location_type,
       [Low Fat] AS low_fat_avg_sales,
       [Regular] AS regular_avg_sales
FROM (
  SELECT outlet_location_type, item_fat_content,
         CAST(AVG(sales) AS DECIMAL(10,2)) AS avg_sales
  FROM Blinkit_Data
  GROUP BY outlet_location_type, item_fat_content
) AS SourceTable
PIVOT (
  AVG(avg_sales)
  FOR item_fat_content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY outlet_location_type;
```
**Pivot: Number of Items by Outlet Location and Fat Content**
```sql
SELECT outlet_location_type,
       [Low Fat] AS low_fat_items,
       [Regular] AS regular_items
FROM (
  SELECT outlet_location_type, item_fat_content,
         COUNT(*) AS item_numbers
  FROM Blinkit_Data
  GROUP BY outlet_location_type, item_fat_content
) AS SourceTable
PIVOT (
  SUM(item_numbers)
  FOR item_fat_content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY outlet_location_type;
```
**Total Sales by Outlet Establishment Year**
```sql
SELECT outlet_establishment_year,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(sales) AS DECIMAL(10,2)) AS average_sales,
       COUNT(*) AS item_number,
       CAST(AVG(rating) AS DECIMAL(10,2)) AS avg_rating
FROM Blinkit_Data
GROUP BY outlet_establishment_year
ORDER BY outlet_establishment_year ASC;
```
**Percentage of Sales by Outlet Size**
```sql
SELECT outlet_size,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(SUM(sales) * 100.00 / SUM(SUM(sales)) OVER() AS DECIMAL(10,2)) AS sales_percentage
FROM Blinkit_Data
GROUP BY outlet_size
ORDER BY total_sales DESC;
```
**Sales by Outlet Location**
```sql
SELECT outlet_location_type,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(SUM(sales) * 100.00 / SUM(SUM(sales)) OVER() AS DECIMAL(10,2)) AS sales_percentage,
       CAST(AVG(sales) AS DECIMAL(10,2)) AS average_sales,
       COUNT(*) AS item_number,
       CAST(AVG(rating) AS DECIMAL(10,2)) AS avg_rating
FROM Blinkit_Data
GROUP BY outlet_location_type
ORDER BY total_sales DESC;
```
**All Metrics by Outlet Type**
```sql
SELECT outlet_type,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(SUM(sales) * 100.00 / SUM(SUM(sales)) OVER() AS DECIMAL(10,2)) AS sales_percentage,
       CAST(AVG(sales) AS DECIMAL(10,2)) AS average_sales,
       COUNT(*) AS item_number,
       CAST(AVG(rating) AS DECIMAL(10,2)) AS avg_rating
FROM Blinkit_Data
GROUP BY outlet_type
ORDER BY total_sales DESC;
```

### Author:
Angeline Joyce J
