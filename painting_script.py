

import pandas as pd
from sqlalchemy import create_engine

conn_string = 'postgresql://postgres:Postgre27@localhost:5433/painting'
db = create_engine (conn_string)
conn = db.connect()

files = ['artist', 'canvas_size', 'image_link', 'museum_hours', 'museum', 'product_size', 'subject', 'work']

base_path= r'C:\Users\user\Downloads\Paintings_datasets)'

for file in files:
    df = pd.read_csv(f'{base_path}/{file}.csv')
    df.to_sql(file, con=conn , if_exists= 'replace', index= False)
