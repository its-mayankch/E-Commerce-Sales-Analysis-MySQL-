use project;
show  tables;

-- =================================================understand data========================================================================================
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


-- ================================================rename column name==========================================================================================

-- customer table
alter table customers rename column customer_id to cust_id;

-- order table
alter table orders rename column customer_id to cust_id;
alter table orders rename column payment_method to pay_method;

-- products table
 alter table products rename column product_category to category;
 alter table products rename column product_price to price;
 
-- reviews table
alter table reviews rename column review_rating to rating;



-- =================================================Handle null values ==========================================================================================
-- customer table
select count(*) from customers
where cust_id is null or
city is null or
state is null or
zipcode is null; 
-- take backup alway before update a table
create table customers_copy as select * from customers;


-- handle null
                                                     
set sql_safe_updates=0;
update customers
set city="unknown"
where city is null;

-- orders table
select sum(order_id is null) as order_null ,
sum(order_date is null) as order_dates_null ,
sum(pay_method is null) as pay_method_null ,
sum(delivery_status is null) as delivery_null,
sum(discount_applied is null)as discount_null ,
sum(order_value is null) as oder_value_null from
orders;

-- take backup alway before update a table
create table orders_copy as select * from orders;

-- handle null value according to category of data
-- date_column handle
select coalesce(order_date,(SELECT MAX(order_date) FROM orders)) as orders_dates from
orders;
UPDATE orders
SET order_date =
(SELECT max_date
    FROM
    (SELECT MAX(order_date) AS max_date
        FROM orders) t)
WHERE order_date IS NULL;

-- category columns
select coalesce(delivery_status,"pending") as delivery_status from
orders;
select coalesce(order_value,0) as orders_value from
orders;
update orders
set delivery_status="pending"
where delivery_status is null;

update orders
set order_value= 0
where order_value is null;

-- products table
-- null exists on or not in whole table

select count( * )from products
where product_id is null or
category is null or
price is null;

-- show which column have null value
select sum(product_id is null) as product_id_null ,
sum(category is null) as category_null ,
sum(price is null) as price_null 
from
products;

-- backup
create table products_copy as select * from products;
                                                         					
-- handle null values
select *,coalesce(price,0) as price from products;

update products
set price=0
where price is null;

-- reviews table
select * from reviews
where order_id is null or
rating is null or
return_requested is null;

select sum(order_id is null) as order_id_null ,
sum(rating is null) as ratings ,
sum(return_requested is null) as return_request
from
reviews;

-- backup
create table reviews_copy as select * from reviews;
                                                         
-- handle null values
select *,coalesce(return_requested,0) as return_requested from
reviews;
update reviews
set return_requested=0
where return_requested is null;

-- order_items table
select * from order_items
where order_id is null or
product_id is null or
quantity is null;

-- -=============================================== duplicates handle=======================================================================

-- check duplicats in customers tables                              
select * from (select * ,row_number()over(partition by cust_id) as row_numb from customers) t
where row_numb>1;

-- add new idenfier column id column and apply auto_inncarement and primary key this is called surrogate Key
-- I added a surrogate primary key, removed duplicates using ROW_NUMBER(), and validated uniqueness before applying constraints.

alter table customers add column id int primary key auto_increment first;

-- duplicate remove
set sql_safe_updates=0;
delete  from customers
where id in (select id from (select * ,row_number()over(partition by cust_id order by id) as row_numb from customers) t where row_numb>1 );

-- order table duplicate check
							 
-- check duplicates
select * from(select order_id,
row_number() over(partition by order_id order by order_id) as
 row_numbers from orders)t
where row_numbers>1;

-- add identifire column id
alter table orders add column id int primary key auto_increment first;
;
--  here  in this table no dupicted values find it
-- products table  
select * from(select *, row_number() 
over(partition by product_id) 
as numbers from products)t
where numbers>1;

-- add new id column as identity column for remove a duplicates
-- I added a surrogate primary key, removed duplicates using ROW_NUMBER(), and validated uniqueness before applying constraints.

alter table products add column id int primary key auto_increment first;

-- drop dulicated values
set sql_safe_updates=0;

DELETE FROM products
WHERE id IN
(SELECT id FROM(SELECT id,
               ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY id) AS numbers
        FROM products) t
WHERE numbers > 1
);
select * from order_items;
										
-- reviews table
select * from (select * ,row_number() over(partition by order_id order by order_id) as numbers from
reviews)t
where numbers>1 ;

-- add new id column as identity column for remove a duplicates
alter table reviews add column id int primary key auto_increment first; 
                                   

-- order_items table 
-- add new id column as identity column for remove a duplicates
alter table order_items add column id int primary key auto_increment first; 
select * from order_items;

-- check duplicates in order_items
select * from(select id,order_id ,row_number() over(partition by order_id order by id) as numbers from
order_items)t
where numbers>1;

-- ================================================= Standard_Text data========================================================================================
select * from customers;
select * from orders;
select * from products;
select * from reviews;
select * from order_items;

-- remove space in customer table
set sql_safe_updates=0;
update customers
set city=trim(city),state=trim(state);
-- case conversion
update customers
set city=lower(city),state=lower(state);
                                               
-- orders table remove and case convertion
update orders
set pay_method=lower(trim(pay_method)),
    delivery_status=lower(trim(delivery_status));
                                                   
-- mapping 
update orders
set pay_method="card"
where pay_method in("credit card", "debit card") ;     
update orders
set delivery_status="completed"
where  delivery_status in('delivered','returned') ; 
               
-- replace black with meaning full values
UPDATE orders
SET pay_method = 'unknown'
WHERE pay_method IS NULL OR pay_method='';

-- Check invalid entries
SELECT DISTINCT pay_method FROM orders;

-- product table
-- remove space and case standeration
update products
set category=lower(trim(category));

-- replace black with meaning full value
update products
set category="unknow"
where category is null or " ";    

-- spelling mapling
update products
set category="home"
where category in("HOME","hm","h","ghar");  
  
-- Check invalid entries                    
select distinct category from products;

-- ======================================================= handle numbers data==================================================================================
-- orders table
update orders
set discount_applied=abs(round(discount_applied,2));

update orders
set discount_applied=0
where discount_applied is null;

-- order_value

update orders
set order_value=abs(round(order_value),2);

-- products table
update products
set price=abs(round(price),2);

-- reviews table
update reviews
set rating=ceil(rating);

-- order_items table
UPDATE order_items
SET quantity = ABS(quantity)
WHERE quantity < 0;

UPDATE order_items
SET quantity = ceil(quantity);

UPDATE order_items
SET quantity = 1
where quantity is null or 0;

-- =================================================== handle date column================================================================================
UPDATE orders
SET order_date = STR_TO_DATE(order_date,'%Y-%m-%d');

-- remove time
UPDATE orders
SET order_date = DATE(order_date);

ALTER TABLE orders ADD order_year INT;

UPDATE orders
SET order_year = YEAR(order_date);
set sql_safe_updates=0;
alter table orders add order_month int;
UPDATE orders
SET order_month = month(order_date);

 -- ==================================================== fixed data type================================================================================
 -- customer_table
alter table customers modify column id int,
modify column cust_id varchar(30),
modify column city varchar(30),
modify column state varchar(20),
modify column zipcode int;
												
-- orders table

alter table orders modify column id int,
modify column order_id varchar(30),
modify column cust_id varchar(30),
modify column order_date date,
modify column pay_method varchar(20),
modify column delivery_status varchar(20),
modify column discount_applied decimal(10,2),
modify column order_value decimal(10,2),
modify column order_year int,
modify column order_month int;

-- products table
alter table products modify column id int,
modify column product_id varchar(30),
modify column category varchar(30),                                           
modify column price decimal(10,2);

-- reviews table
                                               
alter table reviews modify column id int,
modify column order_id varchar(30),
modify column rating int,                                           
modify column return_requested int ;   

-- order_items table
alter table order_items modify column id int,
modify column order_id varchar(30),
modify column product_id varchar(30),                                           
modify column quantity int ;   

-- check validate data
desc customers;
desc orders;
desc products;
desc reviews;
desc order_items;	
     
-- ====================================================Add constraints================================================================================

-- customer_table
alter table customers modify cust_id varchar(20) not null;
alter table customers add constraint uk_cust_id unique(cust_id);

alter table customers modify city varchar(30) not null;
											 #order table
 alter table orders modify order_id varchar(20) not null;
alter table orders add constraint uk_order_id unique(order_id); 

alter table orders add constraint
 fk_cust_id foreign key(cust_id)
 references customers(cust_id);
 
 alter table orders modify order_date date not null;
                                           
-- product table
alter table products modify product_id varchar(20) not null;
alter table  products add constraint uk_product_id unique(product_id); 

alter table products modify price decimal(10,2) default(0);
                                          
-- order_items
alter table  order_items add constraint fk_order_id foreign key(order_id)
references orders(order_id),add constraint fk_product_id foreign key(product_id)
references products(product_id); 

alter table order_items modify quantity int default(1);

-- reviews table
alter table  reviews add constraint fk_ordeer_id foreign key(order_id)
references orders(order_id);  

alter table reviews add constraint ck_req check(return_requested=0 or 1);                                    



                                               