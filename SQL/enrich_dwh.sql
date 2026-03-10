
-- ================================================================
-- Part C: Data Enrichment Script
-- ================================================================

ALTER TABLE dwh.vehicle
    ADD COLUMN vehicle_age INTEGER,
    ADD COLUMN age_category VARCHAR(20),
    ADD COLUMN years_since_registration INTEGER,
    ADD COLUMN is_first_owner BOOLEAN,
    ADD COLUMN license_status VARCHAR(20),
    ADD COLUMN fuel_category VARCHAR(20),
    ADD COLUMN pollution_level VARCHAR(20),
    ADD COLUMN manufacturer_region VARCHAR(20);

-- Step 2: Update Vehicle Age Metrics
UPDATE dwh.vehicle
SET
    vehicle_age = CASE
        WHEN shnat_yitzur IS NOT NULL THEN 2026 - shnat_yitzur
        ELSE NULL
    END,
    age_category = CASE
        WHEN shnat_yitzur IS NULL THEN NULL
        WHEN (2026 - shnat_yitzur) BETWEEN 0 AND 3 THEN 'New'
        WHEN (2026 - shnat_yitzur) BETWEEN 4 AND 7 THEN 'Recent'
        WHEN (2026 - shnat_yitzur) BETWEEN 8 AND 15 THEN 'Mature'
        WHEN (2026 - shnat_yitzur) >= 16 THEN 'Old'
        ELSE NULL
    END;

-- Step 3: Update Registration Metrics
UPDATE dwh.vehicle
SET
    years_since_registration = CASE
        WHEN moed_aliya_lakvish IS NOT NULL THEN
            EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM moed_aliya_lakvish)
        ELSE NULL
    END,
    is_first_owner = CASE
        WHEN moed_aliya_lakvish IS NOT NULL THEN
            (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM moed_aliya_lakvish)) < 1
        ELSE NULL
    END;

-- Step 4: Update License Status
UPDATE dwh.vehicle
SET license_status = CASE
    WHEN tokef_dt IS NULL THEN 'Unknown'
    WHEN tokef_dt < CURRENT_DATE THEN 'Expired'
    WHEN tokef_dt BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '30 days') THEN 'Expiring Soon'
    WHEN tokef_dt > (CURRENT_DATE + INTERVAL '30 days') THEN 'Active'
    ELSE 'Unknown'
END;
