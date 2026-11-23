
import os
from pathlib import Path

import psycopg
from dotenv import load_dotenv

# Locate and load the .env file
BASE_DIR = Path(__file__).resolve().parent
load_dotenv(BASE_DIR / ".env")


def test_connection():

    try:
        # Establish PostgreSQL connection
        with psycopg.connect(
            host=os.getenv("DB_HOST"),
            port=int(os.getenv("DB_PORT", "5432")),
            dbname=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            connect_timeout=5
        ) as connection:

            print("PostgreSQL connection successful!")

            with connection.cursor() as cursor:

                # Retrieve database information
                cursor.execute("""
                    SELECT
                        current_database(),
                        current_user,
                        version();
                """)

                result = cursor.fetchone()

                print("\nDatabase:", result[0])
                print("User:", result[1])
                print("Version:", result[2])

                # Count work orders
                cursor.execute("""
                    SELECT COUNT(*)
                    FROM core.work_orders;
                """)

                total_orders = cursor.fetchone()[0]

                print("\nTotal work orders:", total_orders)

    except Exception as error:
        print("\nConnection failed!")
        print("Error:", error)


if __name__ == "__main__":
    test_connection()
