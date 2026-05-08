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


---->>>> 
-->>> Sales Performance

--> Total Revenue
SELECT 
	SUM(revenue) AS total_revenue 
FROM orditem 	

/*
-----------------
|"total_revenue"|
-----------------
|382613395.18   |
-----------------
*/

--> Average Order Value
SELECT 
    SUM(oi.quantity * p.price) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

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

--> Orders Per Channel
SELECT 
	channel, 
	COUNT(*) AS total_orders
FROM orders
GROUP BY channel;

/*
---------------------------
|"channel"|	"total_orders"|
---------------------------
|"App"	  |	    16654     |
|"Online" |	    16631     |
|"Store"  |	    16715     |
---------------------------
*/

--> Top Products
SELECT 
	p.product_name,
	SUM(oi.quantity) AS total_sold
FROM orditem oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 10;

   -----------------------------------
-- |"product_name"		|"total_sold"|
   -----------------------------------
-- |"Dell Item_452"		|621		 |
-- |"Noise Item_438"	|589		 |
-- |"H&M Item_637"		|573		 |
-- |"Samsung Item_741"	|567		 |
-- |"Ikea Item_519"		|567		 |
-- |"Ikea Item_673"		|563		 |
-- |"Ikea Item_485"		|561		 |
-- |"Apple Item_708"	|561		 |
-- |"Puma Item_202"		|557	 	 |
-- |"Dell Item_603"		|555		 |
   -----------------------------------

--> Total Customers
SELECT COUNT(DISTINCT customer_id) FROM customers;

--> Customer Lifetime Value
SELECT 
    o.customer_id,
    SUM(oi.quantity * p.price) AS customer_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.customer_id;


--> Top customers by revenue
SELECT o.customer_id, 
	SUM(revenue) AS revenue
FROM orders o
JOIN orditem oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.customer_id, revenue
ORDER BY revenue DESC
LIMIT 10;

   ----------------------------
-- |"customer_id"	|"revenue"|
   ----------------------------
-- |"CUST03503"		|16201.08 |
-- |"CUST03751"		|15950.16 |
-- |"CUST03902"		|15894.08 |
-- |"CUST03125"		|15887.60 |
-- |"CUST01954"		|15868.72 |
-- |"CUST04618"		|15745.92 |
-- |"CUST01657"		|15699.84 |
-- |"CUST03180"		|15659.36 |
-- |"CUST00283"		|15654.00 |
-- |"CUST00038"		|15654.00 |
   ----------------------------

--> Repeat Customers
SELECT COUNT(*) 
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) t;

--> Channel-wise Revenue
SELECT 
	o.channel,
	SUM(revenue) AS revenue
FROM orders o
JOIN orditem oi ON o.order_id = oi.order_id
GROUP BY o.channel;

   -----------------------------
-- | "channel" |	"revenue"  |
   -----------------------------
-- | "App"	 	| 128126395.81 |
-- | "Online" 	| 126600445.76 |
-- | "Store"	| 127886553.61 |
   -----------------------------

--> Store VS Online Comparison
SELECT 
    CASE 
        WHEN o.channel IN ('Online', 'App') THEN 'Digital'
        ELSE 'Physical'
    END AS channel_type,
    COUNT(*) AS orders,
    SUM(oi.revenue) AS revenue
FROM orders o
JOIN orditem oi ON o.order_id = oi.order_id
GROUP BY channel_type;

   -------------------------------------------
-- |"channel_type"|	"orders" |	"revenue"	 |
   -------------------------------------------
-- | "Digital"	  |	99626	 |	254726841.57 |
-- | "Physical"	  |	50332	 |	127886553.61 |
   -------------------------------------------

--> Channel Contribution %
SELECT 
    channel,
    SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER () AS contribution_pct
FROM (
    SELECT o.channel,
           SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN orditem oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY o.channel
) t
GROUP BY channel;

--> Return Rate by Channel
SELECT channel,
       COUNT(*) FILTER (WHERE order_status = 'Returned') * 1.0 / COUNT(*) AS return_rate
FROM orders
GROUP BY channel;

/*
-------------------------------------
|"channel"  |	"return_rate"		|
-------------------------------------
|"App"		|0.25063047916416476522 |
|"Online"	|0.25097709097468582767 |
|"Store"	|0.25336524080167514209 |
-------------------------------------
*/


-->>> Inventory Analysis

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

-->>> Trend Analysis
--> Monthly Sales Trend
SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN orditem oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY month
ORDER BY month;

/*
--------------------------------
|     "month"	  |  "revenue"  |
|-------------------------------|
|"2023-01-01 "	  | 15681143.46 |
|"2023-02-01 "	  | 15103801.74 | * LOW
|"2023-03-01 "	  | 16546074.06 | 
|"2023-04-01 "    | 15612625.17 |
|"2023-05-01 "	  | 16358027.13 |
|"2023-06-01 "	  | 15174688.11 | * LOW
|"2023-07-01 "    | 17326224.91 | # HIGH
|"2023-08-01 "    | 15709064.18 |
|"2023-09-01 "    | 16256581.19 |
|"2023-10-01 "    | 16573311.92 |
|"2023-11-01 "    | 15228673.32 |
|"2023-12-01 "    | 16332391.30 |
|"2024-01-01 "    | 15657841.24 |
|"2024-02-01 "    | 15346518.11 |
|"2024-03-01 "    | 15450641.53 |
|"2024-04-01 "    | 15771263.44 |
|"2024-05-01 "    | 16172868.67 |
|"2024-06-01 "    | 15607860.64 |
|"2024-07-01 "    | 16782319.23 |
|"2024-08-01 "    | 16200385.81 |
|"2024-09-01 "    | 15541984.98 |
|"2024-10-01 "    | 16188809.01 |
|"2024-11-01 "    | 15435721.29 |
|"2024-12-01 "    | 16554574.74 |
---------------------------------
*/

-- Top Product Per Category
SELECT *
FROM (
    SELECT 
        p.category,
        p.product_name,
        SUM(oi.quantity) AS total_sold,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity) DESC) AS rank
    FROM orditem oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.category, p.product_name
) t
WHERE rank = 1;

/*
-------------------------------------------------------------
|"category"	    | "product_name"   | "total_sold" |	"rank"  |
|-----------------------------------------------------------|
|"Electronics"	|"Noise Item_438"  |	 589	  |  1		|
|"Fashion"	    |"Samsung Item_741"|	 567	  |  1		|
|"Home"	        |"Ikea Item_519"   |	 567	  |  1		|
|"Sports"	    |"Dell Item_452"   |	 621	  |  1		|
-------------------------------------------------------------
*/

--> Inventory VS Sales
SELECT 
    i.product_id,
    SUM(i.stock_quantity) AS stock,
    SUM(oi.quantity) AS sold
FROM inventory i
LEFT JOIN orditem oi ON i.product_id = oi.product_id
GROUP BY i.product_id;

--> Channel Preference By City
SELECT 
	c.city, 
	o.channel, 
	COUNT(*) AS orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city, o.channel
ORDER BY c.city;

--> Store Performance 
SELECT s.store_id, s.city,
       COUNT(o.order_id) AS total_orders,
       SUM(oi.revenue) AS revenue
FROM stores s
JOIN orders o ON s.store_id = o.store_id
JOIN orditem oi ON o.order_id = oi.order_id
GROUP BY s.store_id, s.city;

--> Inventory Turnover
SELECT 
    i.product_id,
    SUM(oi.quantity) / NULLIF(SUM(i.stock_quantity), 0) AS turnover_ratio
FROM inventory i
LEFT JOIN orditem oi ON i.product_id = oi.product_id
GROUP BY i.product_id;

