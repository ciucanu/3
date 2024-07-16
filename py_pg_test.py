from sqlalchemy import create_engine

# Database configuration
username = 'your_user'
password = 'your_password'
host = 'your_postgres_server'
port = '5432'
database = 'your_db'

# Create the database URL using pg8000 with SSL configuration
DATABASE_URL = f"postgresql+pg8000://{username}:{password}@{host}:{port}/{database}?sslmode=require"

# Create the SQLAlchemy engine
engine = create_engine(DATABASE_URL)

# Test the connection
try:
    with engine.connect() as connection:
        result = connection.execute("SELECT version();")
        for row in result:
            print(row)
except Exception as e:
    print(f"An error occurred: {e}")
