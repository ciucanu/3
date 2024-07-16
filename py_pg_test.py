from sqlalchemy import create_engine

# Database configuration
username = 'your_user'
password = 'your_password'
host = 'your_postgres_server'
port = '5432'
database = 'your_db'

# SSL configuration (if needed)
ssl_mode = 'require'  # Change to 'verify-ca' or 'verify-full' if needed
ssl_root_cert = '/path/to/azure-postgres-root.crt'

# Create the database URL
DATABASE_URL = f"postgresql+psycopg2://{username}:{password}@{host}:{port}/{database}"

# Create the SQLAlchemy engine
engine = create_engine(
    DATABASE_URL,
    connect_args={
        "sslmode": ssl_mode,
        "sslrootcert": ssl_root_cert
    }
)

# Test the connection
try:
    with engine.connect() as connection:
        result = connection.execute("SELECT version();")
        for row in result:
            print(row)
except Exception as e:
    print(f"An error occurred: {e}")
