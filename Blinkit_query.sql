-- BLINK IT Database Project
select * from Blinkit_Data;

-- //* Data Cleaning: 
-- changing the format of words in item_fat_content column *//
update Blinkit_Data
set item_fat_content = 
case
when item_fat_content in('low fat', 'LF') then 'Low Fat' 
when item_fat_content = 'reg' then 'Regular'
else item_fat_content end

-- checking if it's updated
select distinct(item_fat_content) from Blinkit_Data;


-- KPI's Requirements
-- Total Sales:
select cast(sum(sales) as decimal(10,2)) as total_sales from Blinkit_Data;

-- Average Sales:
select cast(avg(sales) as decimal(10,2)) as average_sales from Blinkit_Data;

-- Number of items:
select count(*) as Item_number from Blinkit_Data;

-- Average Rating:
select cast(avg(rating) as decimal(10,2)) as avg_rating from Blinkit_Data;

-- BUSINESS REQUIREMENTS:
-- Total Sales by Fat Content: to analyze the impact of fat content on total sales
select Item_Fat_Content
	,concat(cast(sum(sales)/1000 as decimal(10,2)), ' k') as total_sales_thousands
	,cast(avg(sales) as decimal(10,2)) as average_sales
	,count(*) as Item_number
	,cast(avg(rating) as decimal(10,2)) as avg_rating
	from Blinkit_Data
group by Item_Fat_Content
order by total_sales_thousands desc;

-- Total Sales by item type : 
-- Identify the performance of different item types in terms of total sales

select item_type
	,concat(cast(sum(sales)/ 1000 as decimal(10,2)), ' K') as total_sales_thousands 
	,cast(avg(sales) as decimal(10,2)) as avg_sales
	,count(*) as Item_numbers
	,cast(avg(rating) as decimal(10,2)) as avg_rating
from Blinkit_Data
group by item_type
order by total_sales_thousands desc;

-- Fat content by outlet for total sales:
-- compare total sales across different outlets segmented by fat content
-- before pivoting
select Outlet_location_type, Item_Fat_Content
	,concat(cast(sum(sales)/ 1000 as decimal(10,2)), ' K') as total_sales 
from Blinkit_Data
group by Outlet_location_type, Item_Fat_Content
order by total_sales desc;

-- After Pivoting
-- Total Sales:
select outlet_location_type,
	   [Low Fat] as Low_fat_sales,
	   [Regular] as Regular_sales
from (
select outlet_location_type,
	   item_fat_content,
	   cast(sum(sales)/ 1000 as decimal(10,2)) as total_sales
from Blinkit_Data
group by outlet_location_type,
	   item_fat_content)
as SourceTable
PIVOT (
sum(total_sales)
for item_fat_content in([Low Fat], [Regular])
) as PivotTable
order by outlet_location_type;

-- Average Sales:
select outlet_location_type,
	   [Low Fat] as Low_fat_sales,
	   [Regular] as Regular_sales
from (
select outlet_location_type,
	   item_fat_content,
	   cast(avg(sales) as decimal(10,2)) as avg_sales
from Blinkit_Data
group by outlet_location_type,
	   item_fat_content)
as SourceTable
PIVOT (
avg(avg_sales)
for item_fat_content in([Low Fat], [Regular])
) as PivotTable
order by outlet_location_type;

-- Number of items:
select outlet_location_type,
	   [Low Fat] as Low_fat_sales,
	   [Regular] as Regular_sales
from (
select outlet_location_type,
	   item_fat_content,
	   count(*) as item_numbers
from Blinkit_Data
group by outlet_location_type,
	   item_fat_content)
as SourceTable
PIVOT (
sum(item_numbers)
for item_fat_content in([Low Fat], [Regular])
) as PivotTable
order by outlet_location_type;

select * from Blinkit_Data;

-- Total sales by outlet establishment
select outlet_establishment_year, 
       cast(sum(sales) as decimal(10,2)) as total_sales,
	   cast(avg(sales) as decimal(10,2)) as average_sales,
	   count(*) as Item_number,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from Blinkit_Data
group by outlet_establishment_year
order by outlet_establishment_year asc;

-- Percentage of sales by outlet size:
select outlet_size,
	   cast(sum(sales) as decimal(10,2)) as total_sales,
	   cast(sum(sales) * 100.00 / sum(sum(sales)) over() as decimal(10,2)) as sales_percentage
from Blinkit_Data
group by outlet_size
order by total_sales desc;

-- Sales by outlet location 
select Outlet_Location_Type,
	   cast(sum(sales) as decimal(10,2)) as total_sales,
	   cast(sum(sales) * 100.00 / sum(sum(sales)) over() as decimal(10,2)) as sales_percentage,
	   cast(avg(sales) as decimal(10,2)) as average_sales,
	   count(*) as Item_number,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from Blinkit_Data
group by Outlet_Location_Type
order by total_sales desc;

-- All metrics by outlet type:
select Outlet_type,
	   cast(sum(sales) as decimal(10,2)) as total_sales,
	   cast(sum(sales) * 100.00 / sum(sum(sales)) over() as decimal(10,2)) as sales_percentage,
	   cast(avg(sales) as decimal(10,2)) as average_sales,
	   count(*) as Item_number,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from Blinkit_Data
group by Outlet_type
order by total_sales desc;
