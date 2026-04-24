/* ------------------------------------------------------
					Raw Files Loaded
------------------------------------------------------ */

--> Customers Table
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(20),
    signup_date DATE
);

--> Products Table
CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    brand VARCHAR(50),
    price DECIMAL(10,2)
);

--> Stores Table
CREATE TABLE stores (
    store_id VARCHAR(20) PRIMARY KEY,
    city VARCHAR(20),
    store_type VARCHAR(20)
);

--> Warehouses Table
CREATE TABLE warehouses (
    warehouse_id VARCHAR(20) PRIMARY KEY,
    city VARCHAR(20),
    capacity INT
);

-- Inventory Table
CREATE TABLE inventory (
    product_id VARCHAR(20),
    warehouse_id VARCHAR(20),
    stock_quantity INT,
    last_updated DATE,
    
    PRIMARY KEY (product_id, warehouse_id),
    
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

--> Inventory Movements Table
CREATE TABLE invmove (
    product_id VARCHAR(20),
    warehouse_id VARCHAR(20),
    change_qty INT,
    reason VARCHAR (20),  -- Sale / Return / Restock
    movement_date DATE,
    
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

--> Orders Table
CREATE TABLE orders (
    order_id VARCHAR (20) PRIMARY KEY,
    customer_id VARCHAR (20),
    order_date DATE,
    channel VARCHAR (20),   -- Online / App / Store
    store_id VARCHAR (20),  -- NULL for online/app
    order_status VARCHAR (20),
    order_year int,
	order_month int,
	
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	FOREIGN KEY (store_id) REFERENCES stores(store_id)
);


--> Order Items Table
CREATE TABLE orditem (
    order_item_id INT PRIMARY KEY,
    order_id VARCHAR,
    product_id VARCHAR,
    quantity INT,
	price DECIMAL(10,2),
	revenue DECIMAL(10,2),
	
    
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);




