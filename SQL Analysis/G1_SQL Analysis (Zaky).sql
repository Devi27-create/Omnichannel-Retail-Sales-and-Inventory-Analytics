/* SUMMARY

-- 1. Revenue Over Time
Transactions have approximately similar percentage value of delivered, shipped, returned, and cancelled revenue.
around 1/4 for each. Yet the net_revenue ranging from 3.1M to 4.6M, lead by 
Jan 23 (4.6M) followed by Dec 24 (4.5M) and Sep 23 (4.4M). Meanwhile the bottom 3 placed by 
Apr 23 (3.1M) followed by Sep 24 (3.5M) and Oct 24 (3.5M).

-- 2. Best Sales Product over Time
Considering delivered and shipped status transaction, Ikea Item_519 from Home category became 
best sales product with 323 pcs sold within 2 years. Followed by Samsung Item_630 (Fashion, 308 pcs) and
Ikea Item_418 (Home, 301 pcs). 

-- 3. Cancelled and Returned Product over Time
Meanwhile, considering cancelled and returned transasction, Dell Item_452 (Sport, 186 pcs) should be evaluated
as being top 1 cancelled product followed by Puma Item_745 (Elect, 174) and Ikea Item_673 (Elect, 174). 
It is also concerning since company have approximately number of quantity for returned product with
Boat Item_701 (Home, 190) and Samsung Item_193 (Sport, 176) being top 2 here.

-- 4. Product Performance by Revenue
Speaking about delivered and shipped revenue transaction, Dell Item_452 (Sport, 565K), Noise Item_330
(Fashion, 554K), and Zara item_295 (Fashion, 551K) generated highest revenue regardless margin calculation.
Other way, it is found that H&M Item_425 (Home, 2.4K) and Decathlon Item_556 (Home, 2.7K) performed worst in it.

-- 5. Store and City Performance by revenue
ONLINE (127M) store still rank first and generated the highest revenue among any other store,
regarding delivered and shipped transaction. Followed by STORE024 (Mall, 1,59M) in Hyderabad and 
STORE014 (High Street, 1.51M) in Chennai, the gap was huge. Compared to bottom performance,
STORE009 (Warehouse, 953K) in Kolkata and STORE018 (High Street, 1.06M) placed last. But the number
indicated that, excluding online channel, the differences seems quite low.

-- 6. Online Channel Comparison by Revenue
Digging online and considering delivered and shipped transaction, App (64M) and Online (63M) just differed by 1M.

-- 7. Basket Analysis by Average Order Value
Sticking to delivered and shipped transaction, the highest order value (30K) and the lowest (14) distributed widely
Yet the average of order value showed 7.6K with 4.9K standard deviation indicated that every transaction mostly
have 2.7K to 12.5K order value.

-- 8. Customer Loyalty by Order Count and Revenue Generated
Within 2023-2024 and valid transaction, Mia Rossi (Mumbai, 23/09/10, 15, 135K) have highest frequency of buying.
But Leo Kapoor (Delhi, 22/06/12, 13, 166K) Generate highest revenue.Despite that, average total order value
for each customer is 38K with 20K standard deviation, while average order frequency is 5.

-- 9. Customer Distribution and Its Revenue Generated
Among all customer, Chennai (578, 23M) become basis customer for company. But considering other distributions,
the difference seems not significant. Ranging from 504 to 582 customers with Bangalore (18M) at the lowest.
This found considered valid transaction.

-- 10.Cohort Analysis
Based on signup_date and valid trans, number of membered customer decreased significantly in 2024 (1975 to 915).
Meanwhile Legacy segment still loyal to company showed by increased transaction frequency, other segment showed
opposite even though the difference very small.

-- 11. Sales to Stock Ratio
Among 8000 products (800 unique product accross 10 warehouses), only 169 products have 1 to 3 
sales to stock ratio. Most of it have up to 133 ratio indicating that company need 
massive evaluation regarding stocking system.

-- 12.Inventory Turn Over Ratio
All 800 unique product accross 10 warehouses) have low to middle turn over ratio. 
Showed by data, the highest ratio is 0.46 from Ikea Item_54 (Elect). Even almost half of all products
have below 0.25 ratio.
*/



-- 1. Revenue Over Time
with revenue_summary as (
	select o.order_year, o.order_month, 
		round((sum(case when o.order_status = 'Delivered' then i.revenue end))::numeric, 2) delivered_revenue,
		round((sum(case when o.order_status = 'Shipped' then i.revenue end))::numeric, 2) shipped_revenue,
		round((sum(case when o.order_status = 'Returned' then i.revenue end))::numeric, 2) returned_revenue,
		round((sum(case when o.order_status = 'Cancelled' then i.revenue end))::numeric, 2) cancelled_revenue
	from cl_orders o inner join cl_orditem i on o.order_id = i.order_id
	group by 1, 2
)
select
	*,
	round(delivered_revenue + shipped_revenue - returned_revenue, 2) net_revenue,
	round(100 * delivered_revenue / (delivered_revenue + shipped_revenue + returned_revenue + cancelled_revenue), 2) dr_pct,
	round(100 * shipped_revenue / (delivered_revenue + shipped_revenue + returned_revenue + cancelled_revenue), 2) sr_pct,
	round(100 * returned_revenue / (delivered_revenue + shipped_revenue + returned_revenue + cancelled_revenue), 2) rr_pct,
	round(100 * cancelled_revenue / (delivered_revenue + shipped_revenue + returned_revenue + cancelled_revenue), 2) cr_pct
from revenue_summary order by 1, 2
/*
Transactions have approximately similar percentage value of delivered, shipped, returned, and cancelled revenue.
around 1/4 for each. Yet the net_revenue ranging from 3.1M to 4.6M, lead by 
Jan 23 (4.6M) followed by Dec 24 (4.5M) and Sep 23 (4.4M). Meanwhile the bottom 3 placed by 
Apr 23 (3.1M) followed by Sep 24 (3.5M) and Oct 24 (3.5M).
*/


-- 2. Best Sales Product over Time
select
	p.product_id, p.product_name, p.category, p.brand,
	sum(i.quantity) quantity
from cl_orders o inner join cl_orditem i on o.order_id = i.order_id
	inner join cl_products p on i.product_id = p.product_id
where o.order_status in ('Delivered', 'Shipped')
group by 1, 2, 3, 4
order by 5 desc
limit 10
/*
Considering delivered and shipped status transaction, Ikea Item_519 from Home category became 
best sales product with 323 pcs sold within 2 years. Followed by Samsung Item_630 (Fashion, 308 pcs) and
Ikea Item_418 (Home, 301 pcs). 
*/


-- 3. Cancelled and Returned Product over Time
select
	p.product_id, p.product_name, p.category, p.brand,
	sum(case when o.order_status = 'Cancelled' then i.quantity end) cancelled_quantity,
	sum(case when o.order_status = 'Returned' then i.quantity end) Returned_quantity
from cl_orders o inner join cl_orditem i on o.order_id = i.order_id
	inner join cl_products p on i.product_id = p.product_id
group by 1, 2, 3, 4
order by 6 desc
limit 10
/*
Meanwhile, considering cancelled and returned transasction, Dell Item_452 (Sport, 186 pcs) should be evaluated
as being top 1 cancelled product followed by Puma Item_745 (Elect, 174) and Ikea Item_673 (Elect, 174). 
It is also concerning since company have approximately number of quantity for returned product with
Boat Item_701 (Home, 190) and Samsung Item_193 (Sport, 176) being top 2 here.
*/


-- 4. Product Performance by Revenue
select
	p.product_id, p.product_name, p.category, p.brand,
	round(sum(i.revenue)::numeric, 2) total_revenue
from cl_orders o inner join cl_orditem i on o.order_id = i.order_id
	inner join cl_products p on i.product_id = p.product_id
where o.order_status in ('Delivered', 'Shipped')
group by 1, 2, 3, 4
order by 5 desc
limit 10
/*
Speaking about delivered and shipped revenue transaction, Dell Item_452 (Sport, 565K), Noise Item_330
(Fashion, 554K), and Zara item_295 (Fashion, 551K) generated highest revenue regardless margin calculation.
Other way, it is found that H&M Item_425 (Home, 2.4K) and Decathlon Item_556 (Home, 2.7K) performed worst in it.
*/


-- 5. Store and City Performance by revenue
select
	s.store_id, s.city, s.store_type,
	round(sum(i.revenue)::numeric, 2) total_revenue
from cl_orders o inner join cl_orditem i on o.order_id = i.order_id
	inner join cl_stores s on o.store_id = s.store_id
where o.order_status in ('Delivered', 'Shipped')
group by 1, 2, 3
order by 4 desc
limit 10
/*
ONLINE (127M) store still rank first and generated the highest revenue among any other store,
regarding delivered and shipped transaction. Followed by STORE024 (Mall, 1,59M) in Hyderabad and 
STORE014 (High Street, 1.51M) in Chennai, the gap was huge. Compared to bottom performance,
STORE009 (Warehouse, 953K) in Kolkata and STORE018 (High Street, 1.06M) placed last. But the number
indicated that, excluding online channel, the differences seems quite low.
*/


-- 6. Online Channel Comparison by Revenue
select
	o.channel, o.store_id,
	round(sum(i.revenue)::numeric, 2) total_revenue
from cl_orders o inner join cl_orditem i on o.order_id = i.order_id
where o.order_status in ('Delivered', 'Shipped') and o.store_id = 'ONLINE'
group by 1, 2
order by 3 desc
/*
Digging online and considering delivered and shipped transaction, App (64M) and Online (63M) just differed by 1M.
*/


-- 7. Basket Analysis by Average Order Value
with order_value as(
	select
		o.order_id,
		round(sum(i.revenue)::numeric, 2) total_revenue
	from cl_orders o inner join cl_orditem i on o.order_id = i.order_id
	where o.order_status in ('Delivered', 'Shipped')
	group by 1
)
select
	round(stddev(total_revenue), 2) avg_revenue
from order_value
/*
Sticking to delivered and shipped transaction, the highest order value (30K) and the lowest (14) distributed widely
Yet the average of order value showed 7.6K with 4.9K standard deviation indicated that every transaction mostly
have 2.7K to 12.5K order value.
*/


-- 8. Customer Loyalty by Order Count and Revenue Generated
select
	c.customer_name, c.city, c.signup_date,
	count(distinct o.order_id) frequency,
	round(sum(i.revenue)::numeric, 2) total_revenue
from cl_orders o inner join cl_orditem i on o.order_id = i.order_id
	inner join cl_customers c on o.customer_id = c.customer_id 
where o.order_status in ('Delivered', 'Shipped')
group by 1, 2, 3
order by 5 desc, 4 desc
/*
Within 2023-2024 and valid transaction, Mia Rossi (Mumbai, 23/09/10, 15, 135K) have highest frequency of buying.
But Leo Kapoor (Delhi, 22/06/12, 13, 166K) Generate highest revenue.Despite that, average total order value
for each customer is 38K with 20K standard deviation, while average order frequency is 5.
*/


-- 9. Customer Distribution and Its Revenue Generated
select
	c.city,
	count(distinct c.customer_id) distribution,
	count(distinct o.order_id) frequency,
	round(sum(i.revenue)::numeric, 2) total_revenue
from cl_customers c inner join cl_orders o on c.customer_id = o.customer_id
	inner join cl_orditem i on o.order_id = i.order_id
where o.order_status in ('Delivered', 'Shipped')
group by 1
order by 4 desc
/*
Among all customer, Chennai (578, 23M) become basis customer for company. But considering other distributions,
the difference seems not significant. Ranging from 504 to 582 customers with Bangalore (18M) at the lowest.
This found considered valid transaction.
*/


-- 10.Cohort Analysis
with customer_segment as (
	select
		c.customer_id,
		case when c.signup_date < '2023-01-01' then 'Legacy'
			when c.signup_date between '2023-01-01' and '2023-12-31' then 'New 2023'
    	    else 'New 2024' end as segment,
		count(case when o.order_date < '2024-01-01' then o.order_id end) as freq_2023,
		count(case when o.order_date >= '2024-01-01' then o.order_id end) as freq_2024
	from cl_customers c inner join cl_orders o on c.customer_id = o.customer_id
	where o.order_status in ('Delivered', 'Shipped')
	group by 1, 2
)
select
	segment, count(segment) total, 
	sum(freq_2023) freq_2023, sum(freq_2024) freq_2024
from customer_segment
group by 1 order by 2 desc
/*
Based on signup_date and valid trans, number of membered customer decreased significantly in 2024 (1975 to 915).
Meanwhile Legacy segment still loyal to company showed by increased transaction frequency, other segment showed
opposite even though the difference very small.
*/


-- 11. Sales to Stock Ratio
with monthly_sales as (
    select 
        i.product_id,
        count(distinct concat(o.order_year, o.order_month)) total_months_active,
        sum(i.quantity) total_units_sold
    from cl_orditem i inner join cl_orders o ON i.order_id = o.order_id
    where o.order_status in ('Delivered', 'Shipped')
    group by i.product_id
),
avg_sales as (
    select 
        product_id,
        round(total_units_sold::numeric / nullif(total_months_active, 0), 2) avg_monthly_sales
    from monthly_sales
)
select 
    p.product_name,
    p.category,
    inv.stock_quantity current_stock,
    round(s.avg_monthly_sales::numeric, 2) avg_sales_per_month,
    case when s.avg_monthly_sales = 0 then null 
		else round((inv.stock_quantity / s.avg_monthly_sales)::numeric, 2) 
    	end stock_to_sales_ratio
from cl_inventory inv inner join cl_products p on inv.product_id = p.product_id
	left join avg_sales s on inv.product_id = s.product_id
order by 5 desc, 1 asc
/*
Among 8000 products (800 unique product accross 10 warehouses), only 169 products have 1 to 3 
sales to stock ratio. Most of it have up to 133 ratio indicating that company need 
massive evaluation regarding stocking system.
*/


-- 12.Inventory Turn Over Ratio
with movement_summary as (
	select 
        product_id,
        sum(case when reason = 'Sale' then abs(change_qty) else 0 end) total_units_sold,
        sum(case when reason = 'Restock' then change_qty else 0 end) total_units_restocked,
        sum(case when reason = 'Return' then change_qty else 0 end) total_units_returned
    from cl_invmove group by 1
),
stock_levels as (
    select 
        product_id, sum(stock_quantity) current_inventory
    from cl_inventory group by product_id
)
select 
    p.product_name, p.category,
    ms.total_units_restocked, ms.total_units_sold,
    ms.total_units_returned, sl.current_inventory,
    ROUND((ms.total_units_sold::numeric / (sl.current_inventory + ms.total_units_sold)), 2) turnover_index
from cl_products p inner join movement_summary ms on p.product_id = ms.product_id
	inner join stock_levels sl on p.product_id = sl.product_id
order by 7 desc
/*
All 800 unique product accross 10 warehouses) have low to middle turn over ratio. 
Showed by data, the highest ratio is 0.46 from Ikea Item_54 (Elect). Even almost half of all products
have below 0.25 ratio.
*/
