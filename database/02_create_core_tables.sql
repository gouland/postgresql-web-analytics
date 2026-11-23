
/*
=====================================================
PROJECT: PostgreSQL Web Analytics
SCRIPT: 02_create_core_tables.sql
PURPOSE: Create the main relational database tables
DATABASE: postgresql_career_lab
=====================================================
*/

-- ================================================
-- 1. BRANCHES
-- ================================================

CREATE TABLE IF NOT EXISTS core.branches (

    branch_id BIGINT
        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    branch_code VARCHAR(15)
        UNIQUE NOT NULL,

    branch_name VARCHAR(100)
        NOT NULL,

    county VARCHAR(60)
        NOT NULL,

    is_active BOOLEAN
        DEFAULT TRUE,

    created_at TIMESTAMPTZ
        NOT NULL DEFAULT NOW()
);


-- ================================================
-- 2. CLIENTS
-- ================================================

CREATE TABLE IF NOT EXISTS core.clients (

    client_id BIGINT
        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    client_code VARCHAR(20)
        UNIQUE NOT NULL,

    client_name VARCHAR(150)
        NOT NULL,

    industry VARCHAR(80),

    branch_id BIGINT NOT NULL,

    CONSTRAINT fk_client_branch
        FOREIGN KEY (branch_id)
        REFERENCES core.branches(branch_id)
);


-- ================================================
-- 3. TECHNICIANS
-- ================================================

CREATE TABLE IF NOT EXISTS core.technicians (

    technician_id BIGINT
        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    technician_code VARCHAR(20)
        UNIQUE NOT NULL,

    full_name VARCHAR(120)
        NOT NULL,

    home_branch_id BIGINT NOT NULL,

    is_active BOOLEAN
        DEFAULT TRUE,

    CONSTRAINT fk_technician_branch
        FOREIGN KEY (home_branch_id)
        REFERENCES core.branches(branch_id)
);


-- ================================================
-- 4. WORK ORDERS
-- ================================================

CREATE TABLE IF NOT EXISTS core.work_orders (

    work_order_id BIGINT
        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    work_order_ref VARCHAR(30)
        UNIQUE NOT NULL,

    client_id BIGINT NOT NULL,

    branch_id BIGINT NOT NULL,

    assigned_technician_id BIGINT,

    service_type VARCHAR(30)
        NOT NULL,

    scheduled_date DATE NOT NULL,

    completed_at TIMESTAMPTZ,

    status VARCHAR(20)
        DEFAULT 'Scheduled',

    quoted_amount NUMERIC(12,2)
        NOT NULL DEFAULT 0,

    created_at TIMESTAMPTZ
        NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ
        NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_order_client
        FOREIGN KEY (client_id)
        REFERENCES core.clients(client_id),

    CONSTRAINT fk_order_branch
        FOREIGN KEY (branch_id)
        REFERENCES core.branches(branch_id),

    CONSTRAINT fk_order_technician
        FOREIGN KEY (assigned_technician_id)
        REFERENCES core.technicians(technician_id),

    CONSTRAINT chk_service_type
        CHECK (
            service_type IN (
                'Installation',
                'Maintenance',
                'Repair'
            )
        ),

    CONSTRAINT chk_order_status
        CHECK (
            status IN (
                'Scheduled',
                'Assigned',
                'In Progress',
                'Completed',
                'Cancelled',
                'Pending'
            )
        ),

    CONSTRAINT chk_quoted_amount
        CHECK (quoted_amount >= 0)
);


-- ================================================
-- 5. WORK ORDER EVENTS
-- ================================================

CREATE TABLE IF NOT EXISTS core.work_order_events (

    event_id BIGINT
        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    work_order_id BIGINT NOT NULL,

    event_type VARCHAR(40)
        NOT NULL,

    event_timestamp TIMESTAMPTZ
        DEFAULT NOW(),

    event_notes TEXT,

    CONSTRAINT fk_event_work_order
        FOREIGN KEY (work_order_id)
        REFERENCES core.work_orders(work_order_id)
        ON DELETE CASCADE
);


-- ================================================
-- END OF CORE TABLE CREATION
-- ================================================
