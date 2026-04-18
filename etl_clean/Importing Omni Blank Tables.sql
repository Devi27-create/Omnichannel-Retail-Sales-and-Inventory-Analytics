/*
IMPORTING DATASET: BUILDING BLANK TABLES

--CLEAN_PRODUCTS
create table cl_products (
	product_id varchar(20),
	product_name varchar(50),
	category varchar(50),
	brand varchar(50),
	price float
);

--CLEAN ORDERS
create table cl_orders (
	order_id varchar(20),
	customer_id varchar(20),
	order_date date,
	channel varchar(20),
	store_id varchar(20),
	order_status varchar(20),
	order_year int,
	order_month int
);

--CLEAN CUSTOMERS
create table cl_customers (
	customer_id varchar(20),
	customer_name varchar(50),
	city varchar(20),
	signup_date date
);

--CLEAN ORDER ITEMS
create table cl_orditem (
	order_item_id int,
	order_id varchar(20),
	product_id varchar(20),
	quantity int,
	price float,
	revenue float  
);

--CLEAN INVENTORY
create table cl_inventory (
	product_id varchar(20),
	warehouse_id varchar(20),
	stock_quantity int,
	last_updated date 
);

--CLEAN INVENTORY MOVEMENT
create table cl_invmove (
	product_id varchar(20),
	warehouse_id varchar(20),
	change_qty int,
	reason varchar(20),
	"date" date  
);

--CLEAN STORES
create table cl_stores (
	store_id varchar(20),
	city varchar(20),
	store_type varchar(20)
);

--CLEAN WAREHOUSES
create table cl_warehouses (
	warehouse_id varchar(20),
	city varchar(20),
	capacity int
);
*/
