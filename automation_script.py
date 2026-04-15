## 1. Extract (Read Files Automatically)

import pandas as pd

def extract_data(filepath):
    if filepath.endswith(".csv"):
        return pd.read_csv(filepath)
    elif filepath.endswith(".xlsx"):
        return pd.read_excel(filepath)
    else:
        raise ValueError("Unsupported file format")


# 2. Transform (Data Cleaning)

def clean_data(df):
    # Standardize column names
    df.columns = df.columns.str.lower().str.replace(" ", "_")

    # Handle missing values
    df = df.dropna(subset=["id"])
    df.fillna(0, inplace=True)

    # Fix data types
    df["date"] = pd.to_datetime(df["date"], errors="coerce")

    # Remove duplicates
    df = df.drop_duplicates()

    return df


# 3. Data Validation (Important but Often Skipped)

def validate_data(df):
    assert df.isnull().sum().sum() == 0, "Null values detected"
    assert df.shape[0] > 0, "Empty dataset"

### -- For production: Use Great Expectations or Pandera --

# 4. Load (Save or Insert Automatically)

def load_to_csv(df, output_path):
    df.to_csv(output_path, index=False)


## Load to Database (Example: PostgreSQL)

from sqlalchemy import create_engine

engine = create_engine("postgresql://user:password@localhost/db")

def load_to_db(df, table):
    df.to_sql(table, engine, if_exists="replace", index=False)

# 5. Main Pipeline Script (Fully Automated)

from etl.extract import extract_data
from etl.transform import clean_data
from etl.load import load_to_csv

RAW_FILE = "data/raw/input.csv"
OUTPUT_FILE = "data/cleaned/output.csv"

def run_etl():
    df = extract_data(RAW_FILE)
    df = clean_data(df)
    load_to_csv(df, OUTPUT_FILE)

if __name__ == "__main__":
    run_etl()


