create table Shopping_trend_and_customer_behaviour(
row_index int,
Customer_ID int,
Age smallint,
Gender varchar(10),
Item_Purchased varchar(20),
Category varchar(20),
Purchase_Amount_USD int,
Location varchar(20),
Color varchar(20),
Season varchar(10),
Review_Rating numeric(2,1),
Subscription_Status varchar(5),
Shipping_Type varchar(20),
Discount_Applied varchar(5),
Promo_Code_Used varchar(5),
Previous_Purchases smallint, 
Payment_Method varchar(20),
Frequency_of_Purchases varchar(20)
);

/* ====================================================================================================================================
												Inspecting the Raw Data
==================================================================================================================================== */

SELECT * FROM Shopping_trend_and_customer_behaviour LIMIT 10;

-- Count rows and check for nulls
SELECT COUNT(*) AS total_rows FROM Shopping_trend_and_customer_behaviour;

-- Missing values by column
SELECT
    SUM(CASE WHEN row_index IS NULL THEN 1 ELSE 0 END) AS missing_row_index,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS missing_gender,
	SUM(CASE WHEN item_purchased IS NULL THEN 1 ELSE 0 END) AS missing_item_purchased,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS missing_category,
    SUM(CASE WHEN purchase_amount_usd IS NULL THEN 1 ELSE 0 END) AS missing_purchase_amount_usd,
    SUM(CASE WHEN location IS NULL THEN 1 ELSE 0 END) AS missing_location,
	SUM(CASE WHEN color IS NULL THEN 1 ELSE 0 END) AS missing_color,
    SUM(CASE WHEN season IS NULL THEN 1 ELSE 0 END) AS missing_season,
    SUM(CASE WHEN review_rating IS NULL THEN 1 ELSE 0 END) AS missing_review_rating,
    SUM(CASE WHEN subscription_status IS NULL THEN 1 ELSE 0 END) AS missing_subscription_status,
	SUM(CASE WHEN shipping_type IS NULL THEN 1 ELSE 0 END) AS missing_shipping_type,
    SUM(CASE WHEN discount_applied IS NULL THEN 1 ELSE 0 END) AS missing_discount_applied,
    SUM(CASE WHEN promo_code_used IS NULL THEN 1 ELSE 0 END) AS missing_promo_code_used,
	SUM(CASE WHEN previous_purchases IS NULL THEN 1 ELSE 0 END) AS missing_previous_purchases,
    SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END) AS missing_payment_method,
	SUM(CASE WHEN frequency_of_purchases IS NULL THEN 1 ELSE 0 END) AS missing_frequency_of_purchases
FROM Shopping_trend_and_customer_behaviour;

-- no missing data found

/* ====================================================================================================================================
												Creating a Clean Table
==================================================================================================================================== */

select * into cleaned_Shopping_trend_and_customer_behaviour from Shopping_trend_and_customer_behaviour

select * from cleaned_Shopping_trend_and_customer_behaviour

-- Checking For Null Values

SELECT COUNT(*) - COUNT(age) AS missing_age FROM cleaned_Shopping_trend_and_customer_behaviour;

/* ====================================================================================================================================
										Cleaning and Creating New Features (For Visulaization)
==================================================================================================================================== */

-- deleting the row index column
ALTER TABLE cleaned_Shopping_trend_and_customer_behaviour
DROP COLUMN "row_index";

-- adding age groups
ALTER TABLE cleaned_Shopping_trend_and_customer_behaviour ADD COLUMN age_group TEXT;

UPDATE cleaned_Shopping_trend_and_customer_behaviour
SET age_group = CASE
    WHEN age < 18 THEN '<18'
    WHEN age BETWEEN 18 AND 25 THEN '18-25'
    WHEN age BETWEEN 26 AND 35 THEN '26-35'
    WHEN age BETWEEN 36 AND 45 THEN '36-45'
    WHEN age BETWEEN 46 AND 55 THEN '46-55'
    WHEN age BETWEEN 56 AND 65 THEN '56-65'
    ELSE '65+'
END;

-- Altering yes/no to binary
ALTER TABLE cleaned_Shopping_trend_and_customer_behaviour ADD COLUMN subscription_status_binary INT;

UPDATE cleaned_Shopping_trend_and_customer_behaviour
SET subscription_status_binary = CASE WHEN subscription_status = 'Yes' THEN 1 ELSE 0 END;

ALTER TABLE cleaned_Shopping_trend_and_customer_behaviour ADD COLUMN discount_applied_binary INT;

UPDATE cleaned_Shopping_trend_and_customer_behaviour
SET discount_applied_binary = CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END;

ALTER TABLE cleaned_Shopping_trend_and_customer_behaviour ADD COLUMN promo_code_used_binary INT;

UPDATE cleaned_Shopping_trend_and_customer_behaviour
SET promo_code_used_binary = CASE WHEN promo_code_used = 'Yes' THEN 1 ELSE 0 END;

-- Finding total spending
ALTER TABLE cleaned_Shopping_trend_and_customer_behaviour ADD COLUMN total_spendings NUMERIC;

UPDATE cleaned_Shopping_trend_and_customer_behaviour
SET total_spendings = purchase_amount_usd * (previous_purchases + 1);



/* ====================================================================================================================================
										Exporting Cleaned Data For Dashboard (RUNNED IN PSQL TOOL)
==================================================================================================================================== */

\copy cleaned_Shopping_trend_and_customer_behaviour TO 'C:\Users\user\OneDrive\Desktop\datasets\cleaned_Shopping_trend_and_customer_behaviour.csv' WITH (FORMAT CSV, HEADER TRUE);

/* ------------------------------------------------------- "QUERIES END HERE" ------------------------------------------------------- */














