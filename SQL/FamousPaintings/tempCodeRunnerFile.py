import pandas as pd
from sqlalchemy import create_engine

conn_string = 'postgresql://postgres:s8JMc3Qx@localhost/paintings'
db = create_engine(conn_string)
conn = db.connect()

files = ['artist', 'canvas_size', 'image_link', 'museum_hours', 'museum', 'product_size', 'subject', 'work']


for file in files:
  df = pd.read_csv(fr'C:\Users\User\Documents\Data Analysis\gitDataAnalysisProjects\SQL\FamousPaintings\{file}.csv')
  df.to_sql(file, con=conn, if_exists='replace', index=False)
