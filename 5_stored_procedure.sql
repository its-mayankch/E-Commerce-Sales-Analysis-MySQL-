use project;
-- ======================================Stored Procedure: Customer Full Order Details===============================================================================

DELIMITER $$

CREATE PROCEDURE sp_customer_full_details(IN p_cust_id VARCHAR(50))
BEGIN

SELECT 
    c.cust_id,
    c.city,
    c.state,
    c.zipcode,

    o.order_id,
    o.order_date,
    o.pay_method,
    o.delivery_status,
    o.discount_applied,
    o.order_value,

    p.product_id,
    p.category,
    p.price,
    oi.quantity,

    r.rating,
    r.return_requested

FROM customers c
LEFT JOIN orders o 
    ON c.cust_id = o.cust_id
LEFT JOIN order_items oi 
    ON o.order_id = oi.order_id
LEFT JOIN products p 
    ON oi.product_id = p.product_id
LEFT JOIN reviews r 
    ON o.order_id = r.order_id

WHERE c.cust_id = p_cust_id
ORDER BY o.order_date DESC;

END $$

DELIMITER ;

CALL sp_customer_full_details('CUST0001');
select * from customers;

