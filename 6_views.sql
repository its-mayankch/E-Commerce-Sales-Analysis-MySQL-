-- ===============================================view creation========================================================================================
CREATE VIEW vw_product_information AS
SELECT 
    p.product_id,
    p.category,
    p.price,

    -- Total quantity sold
    COALESCE(SUM(oi.quantity),0) AS total_quantity_sold,

    -- Total revenue per product
    COALESCE(SUM(oi.quantity * p.price),0) AS total_revenue,

    -- Average rating
    ROUND(AVG(r.rating),2) AS avg_rating,

    -- Total returns
    SUM(CASE WHEN r.return_requested = 'Yes' THEN 1 ELSE 0 END) AS total_returns

FROM products p
LEFT JOIN order_items oi 
    ON p.product_id = oi.product_id
LEFT JOIN orders o 
    ON oi.order_id = o.order_id
LEFT JOIN reviews r 
    ON o.order_id = r.order_id

GROUP BY 
    p.product_id,
    p.category,
    p.price;
 
 #use view
  
SELECT * 
FROM vw_product_information
ORDER BY total_revenue DESC;
