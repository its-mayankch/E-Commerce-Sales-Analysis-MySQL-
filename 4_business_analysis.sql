use project;
-- =======================================================Understand Table Structure (again quickly)=====================================================================
select * from customers;
select * from orders;
select * from products;
select * from reviews;
select * from order_items;

desc customers;
desc orders;
desc products;
desc reviews;
desc order_items;

SELECT * FROM orders LIMIT 10;

# check business duration
select min(order_date) as first_order,
max(order_date) as last_order from orders;

-- ========================================================  Business Analysis Tasks ======================================================================
-- Total Revenue
select round(sum(order_value),2) as total_revenue from 
orders;

-- Total Orders
select count(distinct order_id) as tota_orders from
orders;

-- Average Order Value
select avg(order_value) as avg_order_value from
orders;

-- Total Customers
select count(distinct cust_id) as total_customers from
customers;

-- Monthly Revenue Trend
select order_year,order_month,
sum(order_value) as total_revenue
from orders
group by order_year,order_month
order by order_year,order_month;

-- Month-over-Month Growth
SELECT *,
ROUND(
(revenue - prev_revenue)/prev_revenue * 100,2
) AS mom_growth
FROM (
   SELECT 
   order_year,
   order_month,
   SUM(order_value) AS revenue,
   LAG(SUM(order_value)) OVER(ORDER BY order_year, order_month) AS prev_revenue
   FROM orders
   GROUP BY order_year, order_month
) t;



-- Top Cities by Revenue
select c.city as city ,round(sum(o.order_value),2) as total_revenue from
customers c join orders o 
on c.cust_id=o.cust_id
group by c.city
order by total_revenue desc
limit 10;


-- Repeat Customers

SELECT cust_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY cust_id
HAVING COUNT(order_id) > 1;

-- Top Selling Products
select p.product_id,p.category as top_selling_products,sum(o.quantity) as total_qantity from
products p inner join order_items o on p.product_id=o.product_id
group by p.product_id, top_selling_products
order by total_qantity desc
limit 10;

-- Category Contribution % in revenue
select p.category,
round(sum(o.order_value),2) as revenue,
round(100*sum(o.order_value)/sum(sum(o.order_value))over(),2)
as contribution_cat
from order_items oi join 
products p ON p.product_id = oi.product_id
join orders o 
on oi.order_id = o.order_id
group by p.category
order by revenue desc  ;


-- Average Rating Per Category
select p.category as category ,
avg(r.rating) as avg_rating
from reviews r 
join order_items o 
on r.order_id=o.order_id
join products p
on p.product_id=o.product_id
group by p.category;

-- Return Rate
SELECT 
COUNT(CASE WHEN return_requested=1 THEN 1 END)/COUNT(*)*100 AS return_percent
FROM reviews;


-- Delivery Performance
SELECT 
delivery_status,
COUNT(*) AS total_orders
FROM orders
GROUP BY delivery_status;


#Top 3 Products Per Category
select * from (select  p.product_id,p.category,sum(o.quantity) as total_qty ,
dense_rank() over(partition by p.category order by sum(o.quantity)desc) as rnk from 
products p join order_items o
on p.product_id=o.product_id
group by p.category ,p.product_id)t
where rnk< 4;


















