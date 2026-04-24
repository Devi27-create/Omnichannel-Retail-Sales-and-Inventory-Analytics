-->>> Revenue KPIs

--> Total Revenue
SELECT 
	SUM(revenue) AS total_revenue 
FROM orditem 

--> Average Order Value
SELECT 
    SUM(revenue) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM orders o
JOIN orditem oi ON o.order_id = oi.order_id;

-->>> Order KPIs

--> Total Orders
SELECT COUNT(*) AS total_orders FROM orders;

--> Return Rate
SELECT 
    COUNT(*) FILTER (WHERE order_status = 'Returned') * 1.0 / COUNT(*) AS return_rate
FROM orders;

--> Cancellation Rate
SELECT 
    COUNT(*) FILTER (WHERE order_status = 'Cancelled') * 1.0 / COUNT(*) AS cancel_rate
FROM orders;

-->>> Customer KPIs

--> Total Customers
SELECT COUNT(DISTINCT customer_id) FROM customers;

--> Customer Lifetime Value
SELECT 
    o.customer_id,
    SUM(oi.revenue) AS customer_revenue
FROM orders o
JOIN orditem oi ON o.order_id = oi.order_id
GROUP BY o.customer_id;

--> Repeat Customers
SELECT COUNT(*) 
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) t;

-->>> Channel KPIs

--> Revenue by Channel
SELECT o.channel,
       SUM(oi.revenue) AS revenue
FROM orders o
JOIN orditem oi ON o.order_id = oi.order_id
GROUP BY o.channel;

--> Channel Contribution %
SELECT 
    channel,
    SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER () AS contribution_pct
FROM (
    SELECT o.channel,
           SUM(revenue) AS revenue
    FROM orders o
    JOIN orditem oi ON o.order_id = oi.order_id
    GROUP BY o.channel
) t
GROUP BY channel;

-->>> Inventory KPIs

--> Total Stock
SELECT SUM(stock_quantity) FROM inventory;

--> Current Stock per Warehouse
SELECT 
	warehouse_id,
	SUM(stock_quantity) AS total_stock
FROM inventory
GROUP BY warehouse_id;

--> Low stock Products
SELECT 
	product_id, 
	warehouse_id, 
	stock_quantity
FROM inventory
WHERE stock_quantity < 50;

--> Net Inventory Change
SELECT SUM(change_qty) FROM invmove;

--> Inventory Movement
SELECT 
	reason, 
	SUM(change_qty) AS total_change
FROM invmove
GROUP BY reason;

--> Net Stock Change Per Product
SELECT 
	product_id, 
	SUM(change_qty) AS net_change
FROM invmove
GROUP BY product_id
ORDER BY net_change;

--> Inventory Turnover
SELECT 
    SUM(oi.quantity) / NULLIF(SUM(i.stock_quantity), 0) AS turnover_ratio
FROM inventory i
LEFT JOIN order_items oi ON i.product_id = oi.product_id;

-->>> Time-Based KPIs
--> Monthly Revenue
SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(revenue) AS revenue
FROM orders o
JOIN orditem oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;


