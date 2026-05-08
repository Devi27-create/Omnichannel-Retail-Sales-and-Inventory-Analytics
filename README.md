# Omnichannel Retail Sales & Inventory Analytics

## Project Overview

This project analyzes an omnichannel retail business by integrating data across customers, orders, products, inventory, and warehouses.

The goal is to:

- Understand sales performance across channels (Store, Online, App)
- Track inventory movements and stock levels
- Analyze customer behavior and retention
- Build a scalable data model for business intelligence
  
## Tech Stack

- Python (Pandas, NumPy): Data cleaning & preprocessing
- SQL: Data modeling & analysis
- Power BI: Dashboard & visualization
- Git & GitHub:  Version control

## Dataset Description

The project uses multiple relational datasets:

- customers: Customer details
- orders: Order-level data (channel, status, date)
- order_items: Product-level transactions
- products: Product catalog
- inventory: Stock levels per warehouse
- inventory_movements: Stock inflow/outflow
- stores: Store metadata
- warehouses: Warehouse capacity & location

![Data Relationship Diagram](https://github.com/Devi27-create/Omnichannel-Retail-Sales-and-Inventory-Analytics/blob/main/Clean%20Dataset/G1_Clean%20Relationship%20Diagram.jpeg)

## Data Pipeline
**1. Data Cleaning (Python)**
- Standardized column names
- Removed duplicates and invalid values
- Converted date formats
- Handled missing values (e.g., online store mapping)
- Fixed inventory movement logic (positive/negative quantities)
- Created derived columns (revenue, order_year, order_month)

**2. Data Validation**
- Primary Key checks (uniqueness)
- Foreign Key checks (no orphan records)
- Data type standardization
  
**3. Data Engineering**
- Revenue calculation (quantity × price)
- Time-based features (Year, Month)
- Inventory normalization (stock movement logic)

## Data Model (Power BI)

Star schema design:

- Fact Tables
   - order_items (sales)
   - inventory_movements (stock flow)
- Dimension Tables
   - customers
   - products
   - stores
   - warehouses
   - date
  
## Key KPIs
- Total Revenue
- Total Orders
- Average Order Value (AOV)
- Customer Retention Rate
- Inventory Turnover
- Stock Movement Trends

## Dashboard Features
- Sales by Channel (Store vs Online vs App)
- Monthly Revenue Trends
- Top Products & Categorie
- Inventory Inflow vs Outflow
- Warehouse Stock Distribution

## Key Insights
- Online/App channels contribute significantly to total orders
- Certain product categories dominate revenue
- Inventory movement patterns highlight restocking inefficiencies
- Customer retention trends vary across acquisition periods

## Challenges & Solutions
- Missing Store IDs for Online Orders: Handled using placeholder mapping
- Incorrect Inventory Movement Signs: Standardized using business rules
- Zero Change Quantity Records: Identified and cleaned during preprocessing

## How to Run the Project
### Clone repository
`git clone <your-repo-link>`

### Open notebook
`G1_Python Data Cleaning.ipynb`


