/*
PROJECT: PostgreSQL Web Analytics
SCRIPT: 01_create_schemas.sql
PURPOSE: Create logical database schemas
*/

CREATE SCHEMA IF NOT EXISTS raw;

CREATE SCHEMA IF NOT EXISTS staging;

CREATE SCHEMA IF NOT EXISTS core;

CREATE SCHEMA IF NOT EXISTS mart;

CREATE SCHEMA IF NOT EXISTS audit;