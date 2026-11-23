# PostgreSQL Database Scripts

This directory contains SQL scripts used to build,
populate, maintain and analyse the PostgreSQL database.

## Execution Order

1. 00_create_database.sql
2. 01_create_schemas.sql
3. 02_create_core_tables.sql
4. 03_create_reference_tables.sql
5. 04_insert_sample_data.sql
6. 05_database_relationships.sql
7. 06_indexes.sql
8. 07_views.sql
9. 08_functions_procedures.sql
10. 09_triggers.sql
11. 10_analytical_queries.sql

## Database Architecture

- raw: Original imported data
- staging: Data cleaning and transformation
- core: Relational business records
- mart: Analytical reporting structures
- audit: Pipeline execution and data quality records

## Database

PostgreSQL 18.6