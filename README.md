# Omnichannel Retail Sales & Inventory Analytics

## Project Overview

This project analyzes an omnichannel retail business by integrating data across customers, orders, products, inventory, and warehouses.

The goal is to:

- Understand sales performance across channels (Store, Online, App)
- Track inventory movements and stock levels
- Analyze customer behavior and retention
- Build a scalable data model for business intelligence

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

![Data Relationship Diagram](https://github.com/Devi27-create/Omnichannel-Retail-Sales-and-Inventory-Analytics/blob/main/Images/G1_Clean%20Relationship%20Diagram.jpeg)

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

## Project Highlights

**Sales Analytics**
- Revenue trends
- Order trends
- Average Order Value (AOV)
- Revenue by channel
- Revenue by city
- Product/category performance
- Top-selling products

**Customer Analytics**
- Customer Lifetime Value (CLV)
- Customer segmentation
- Repeat rate
- Retention analysis
- Cohort matrix
- Churn analysis
- Active customer trend
- Top customers by CLV

**Inventory Analytics**
- Stock movement tracking
- Warehouse occupancy
- Inventory turnover ratio
- Low stock monitoring
- Stock-to-sales ratio
- Inventory movement reasons
- Store type revenue contribution

## Dashboard Pages

### 1. Executive Overview Dashboard

Provides high-level business KPIs and trends.

**Features**
- Total Revenue
- Active Members
- Total Orders
- Revenue Trend
- Orders Trend
- Revenue by Channel
- Revenue by City (Map)

### 2. Product & Sales Insight Dashboard

Deep analysis of products, categories, and sales behavior.

**Features**
- Top Revenue Products
- Top Cancelled Products
- Top Returned Products
- Category Performance
- Revenue vs Quantity Sold
- City Contribution Analysis

### 3. Inventory & Operations Dashboard

Operational monitoring for inventory and warehouse management.

**Features**
- Total Stock
- Low Stock Count
- Inventory Turnover Index
- Warehouse Occupancy
- Inventory Change by Reason
- Stock Movement Trend
- Orders by Day
- Revenue by Store Type

### 4. Customer Analytics Dashboard

Advanced customer behavior analysis.

**Features**
- Average Customer Lifetime Value (CLV)
- Customer Segmentation
- Retention %
- Repeat Rate %
- Cohort Matrix
- Active Customer Trend
- Channel Analysis
- Top Customers by CLV

## Advanced Analytics Implemented

### Cohort Analysis

Used to analyze customer retention behavior over time.

**Metrics**
- Cohort Month
- Cohort Index
- Retention %
- Churn %

### Customer Lifetime Value (CLV)

Measures long-term customer value using revenue contribution.

### Customer Segmentation

Customers segmented into:

- High Value
- Medium Value
- Low Value

### Churn Analysis

Identifies customer drop-off behavior.

## Data Model (Power BI)

This project follows a Star Schema architecture.

- Fact Tables
   - order_items (sales)
   - inventory_movements (stock flow)
- Dimension Tables
   - customers
   - products
   - stores
   - warehouses
   - date table

## Tech Stack

| Tool                   | Purpose                       |
| ---------------------- | ----------------------------- |
| Python (Pandas, NumPy) | Data cleaning & preprocessing |
| SQL                    | Data modeling & analysis      |
| Power BI               | Dashboard & Visualization     |
| DAX                    | Business Logic & KPIs         |
| Excel/CSV              | Data Source                   |
| Git & GitHub           | Version Control               |

## Dashboard Screenshots

### Executive Overview

![Executive Overview](https://github.com/Devi27-create/Omnichannel-Retail-Sales-and-Inventory-Analytics/blob/main/Images/G-1%20Omni%20Dashboard%20pg1.png)

### Product & Sales Dashboard

![Product & Sales](https://github.com/Devi27-create/Omnichannel-Retail-Sales-and-Inventory-Analytics/blob/main/Images/G-1%20Omni%20Dashboard%20pg2.png)

### Inventory & Operations Dashboard

![Inventory & Operations](https://github.com/Devi27-create/Omnichannel-Retail-Sales-and-Inventory-Analytics/blob/main/Images/G-1%20Omni%20Dashboard%20pg3.png)

### Customer Analytics Dashboard

![Customer Analytics](https://github.com/Devi27-create/Omnichannel-Retail-Sales-and-Inventory-Analytics/blob/main/Images/G-1%20Omni%20Dashboard%20pg4.png)

## Key Insights
- Online/App channels contribute significantly to total orders
- Certain product categories dominate revenue
- Inventory movement patterns highlight restocking inefficiencies
- Customer retention trends vary across acquisition periods

## Challenges & Solutions
- Missing Store IDs for Online Orders: Handled using placeholder mapping
- Incorrect Inventory Movement Signs: Standardized using business rules
- Zero Change Quantity Records: Identified and cleaned during preprocessing

## Learning Outcomes

Through this project, I learned:
- Data preprocessing & data cleaning
- Data validation & assertion
- Advanced DAX calculations
- Star schema data modeling
- Cohort and retention analysis
- Customer analytics and segmentation
- Power BI dashboard design
- KPI storytelling
- Git/GitHub workflow
- Business intelligence best practices
- Building portfolio-ready end-to-end analytics solutions

## How to Run the Project
### Clone repository
`git clone <this-repo-link>`

### Open notebook
`G1_Python Data Cleaning.ipynb`


