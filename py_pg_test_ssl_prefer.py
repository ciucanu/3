import ssl
from sqlalchemy import create_engine

# Database configuration
username = 'your_user'
password = 'your_password'
host = 'your_postgres_server'
port = '5432'
database = 'your_db'

# Path to the SSL root certificate
ssl_root_cert = '/path/to/azure-postgres-root.crt'  # Update this path

# Create a custom SSL context
ssl_context = ssl.create_default_context()
ssl_context.verify_mode = ssl.CERT_REQUIRED  # Change to ssl.CERT_NONE or ssl.CERT_OPTIONAL as needed
ssl_context.load_verify_locations(ssl_root_cert)

# Create the database URL using pg8000
DATABASE_URL = f"postgresql+pg8000://{username}:{password}@{host}:{port}/{database}"

# Create the SQLAlchemy engine with SSL verification
engine = create_engine(
    DATABASE_URL,
    connect_args={
        "ssl_context": ssl_context
    }
)

# Test the connection and list databases
try:
    with engine.connect() as connection:
        result = connection.execute("SELECT datname FROM pg_database WHERE datistemplate = false;")
        for row in result:
            print(row)
except Exception as e:
    print(f"An error occurred: {e}")
