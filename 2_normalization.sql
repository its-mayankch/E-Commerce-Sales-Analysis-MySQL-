-- =========================================Normalization of data===============================================================================================
 /*
    IDENTIFY DEPENDENCIES
   customer_id -> city,state,zipcode
   product_id -> product_category,product_price
   order_id -> order_date,payment,delivery,discount,value
   order_id + product_id -> quantity
   order_id -> review,return
    */
    
   
   -- =============================================================================================================================================================
                                             -- create customers table
-- =================================================================================================================================================================

CREATE TABLE customers (
 customer_id VARCHAR(50) ,
 city VARCHAR(100),
 state VARCHAR(100),
 zipcode INT
);

INSERT INTO customers
SELECT DISTINCT customer_id, city, state, zipcode
FROM raw_orders;

-- =================================================================================================================================================================
                                             -- CREATE PRODUCTS TABLE
-- =================================================================================================================================================================

CREATE TABLE products (
 product_id VARCHAR(50),
 product_category VARCHAR(100),
 product_price DECIMAL(10,2)
);

INSERT INTO products
SELECT DISTINCT product_id, product_category, product_price
FROM raw_orders;

-- ===================================================================================================================================================================
                                             -- CREATE ORDERS TABLE
-- ===================================================================================================================================================================

CREATE TABLE orders (
 order_id VARCHAR(50) ,
 customer_id VARCHAR(50),
 order_date DATE,
 payment_method VARCHAR(50),
 delivery_status VARCHAR(50),
 discount_applied DECIMAL(5,2),
 order_value DECIMAL(10,2)
 
);

INSERT INTO orders
SELECT DISTINCT order_id, customer_id, order_date,
payment_method, delivery_status, discount_applied, order_value
FROM raw_orders;

-- =============================================================================================================================================================
											 -- CREATE ORDER_ITEMS 
-- ==============================================================================================================================================================

CREATE TABLE order_items (
 order_id VARCHAR(50),
 product_id VARCHAR(50),
 quantity INT
 
);

INSERT INTO order_items
SELECT order_id, product_id, quantity
FROM raw_orders;

-- ================================================================================================================================================================
											-- CREATE REVIEWS TABLE
-- ================================================================================================================================================================

CREATE TABLE reviews (
 order_id VARCHAR(50) ,
 review_rating INT,
 return_requested BOOLEAN
 
);

INSERT INTO reviews
SELECT DISTINCT
order_id,
review_rating,
CASE
   WHEN return_requested = 'True' THEN 1
   WHEN return_requested = 'False' THEN 0

   ELSE NULL
END
FROM raw_orders;

-- =====================================================================================================================================================================
                                         -- VALIDATION USING JOINS
-- ====================================================================================================================================================================
SELECT o.order_id, c.city, p.product_category, oi.quantity
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LIMIT 10;