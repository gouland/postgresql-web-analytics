
/*
=====================================================
PROJECT: PostgreSQL Web Analytics
SCRIPT: 03_create_reference_tables.sql
PURPOSE: Create reference and junction tables
=====================================================
*/

-- ================================================
-- 1. CERTIFICATIONS REFERENCE TABLE
-- ================================================

CREATE TABLE IF NOT EXISTS core.certifications (

    certification_id BIGINT
        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    certification_code VARCHAR(20)
        UNIQUE NOT NULL,

    certification_name VARCHAR(100)
        UNIQUE NOT NULL,

    issuing_body VARCHAR(100),

    validity_months INTEGER,

    CONSTRAINT chk_validity_months
        CHECK (validity_months > 0)
);


-- ================================================
-- 2. TECHNICIAN CERTIFICATIONS JUNCTION TABLE
-- ================================================

CREATE TABLE IF NOT EXISTS core.technician_certifications (

    technician_id BIGINT NOT NULL,

    certification_id BIGINT NOT NULL,

    date_obtained DATE NOT NULL,

    expiry_date DATE,

    CONSTRAINT pk_technician_certifications
        PRIMARY KEY (
            technician_id,
            certification_id
        ),

    CONSTRAINT fk_tc_technician
        FOREIGN KEY (technician_id)
        REFERENCES core.technicians(technician_id),

    CONSTRAINT fk_tc_certification
        FOREIGN KEY (certification_id)
        REFERENCES core.certifications(certification_id),

    CONSTRAINT chk_certification_dates
        CHECK (
            expiry_date IS NULL
            OR expiry_date >= date_obtained
        )
);


/*
=====================================================
END OF REFERENCE TABLE CREATION
=====================================================
*/
