
import os
from pathlib import Path

import psycopg
from psycopg.rows import dict_row
from dotenv import load_dotenv

from flask import Flask, jsonify, render_template


# ==================================================
# 1. APPLICATION CONFIGURATION
# ==================================================

BASE_DIR = Path(__file__).resolve().parent

load_dotenv(BASE_DIR / ".env")

app = Flask(__name__)


# ==================================================
# 2. POSTGRESQL CONNECTION
# ==================================================

def get_db_connection():

    return psycopg.connect(
        host=os.getenv("DB_HOST"),
        port=int(os.getenv("DB_PORT", "5432")),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        connect_timeout=5,
        row_factory=dict_row
    )


# ==================================================
# 3. HOMEPAGE
# ==================================================

@app.route("/", methods=["GET"])
def home():

    return render_template("index.html")


# ==================================================
# 4. HEALTH CHECK API
# ==================================================

@app.route("/api/health", methods=["GET"])
def health_check():

    return jsonify({
        "status": "success",
        "message": "Flask backend is running!"
    })


# ==================================================
# 5. WORK ORDERS API
# ==================================================

@app.route("/api/work-orders", methods=["GET"])
def get_work_orders():

    try:

        with get_db_connection() as connection:

            with connection.cursor() as cursor:

                cursor.execute("""
                    SELECT
                        wo.work_order_id,
                        wo.work_order_ref,
                        c.client_name,
                        b.branch_name,
                        t.full_name AS technician_name,
                        wo.service_type,
                        wo.scheduled_date,
                        wo.status,
                        wo.quoted_amount

                    FROM core.work_orders wo

                    INNER JOIN core.clients c
                        ON wo.client_id = c.client_id

                    INNER JOIN core.branches b
                        ON wo.branch_id = b.branch_id

                    LEFT JOIN core.technicians t
                        ON wo.assigned_technician_id =
                           t.technician_id

                    ORDER BY
                        wo.scheduled_date,
                        wo.work_order_id;
                """)

                rows = cursor.fetchall()

                records = []

                for row in rows:

                    record = dict(row)

                    # Convert date into JSON-compatible string
                    record["scheduled_date"] = (
                        row["scheduled_date"].isoformat()
                        if row["scheduled_date"]
                        else None
                    )

                    # Preserve decimal precision
                    record["quoted_amount"] = str(
                        row["quoted_amount"]
                    )

                    records.append(record)

                return jsonify({
                    "status": "success",
                    "count": len(records),
                    "data": records
                })

    except Exception:

        app.logger.exception(
            "Failed to retrieve work orders"
        )

        return jsonify({
            "status": "error",
            "message": "Unable to retrieve work orders."
        }), 500


# ==================================================
# 6. START FLASK SERVER
# ==================================================

if __name__ == "__main__":

    app.run(
        host="127.0.0.1",
        port=5000,
        debug=True
    )
