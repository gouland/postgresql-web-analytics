
# PostgreSQL Web Analytics

A PostgreSQL-powered web application built using Python Flask,
HTML, CSS and JavaScript.

## Project Overview

This project demonstrates how to connect a PostgreSQL database
to a web application and retrieve database records dynamically.

## Technology Stack

- PostgreSQL 18.6
- Python
- Flask
- Psycopg 3
- HTML5
- CSS3
- JavaScript
- Git and GitHub

## Current Features

- PostgreSQL database connectivity
- Flask backend
- REST API endpoints
- Dynamic work order retrieval
- SQL joins across relational tables
- HTML dashboard
- KPI calculations
- Work order search and filtering

## Project Structure

- app.py: Flask backend
- test_db.py: Database connection testing
- templates/: HTML templates
- static/css/: Stylesheets
- static/js/: JavaScript files

## Setup

1. Clone the repository.
2. Create a Python virtual environment.
3. Install dependencies using requirements.txt.
4. Create a .env file using .env.example.
5. Configure your PostgreSQL connection.
6. Run the application.

## Install Dependencies

```bash
pip install -r requirements.txt
```

## Run Application

```bash
python app.py
```

Open http://127.0.0.1:5000/

## Database

Database: postgresql_career_lab

The application uses a dedicated read-only PostgreSQL user.

## Author

Gouland
