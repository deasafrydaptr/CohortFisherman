-- Cleaning Data
WITH base_table AS (
    SELECT 
        id_nelayan,
        id_buying,
        date_buying,
        month,
        year,
        COALESCE(NULLIF(category, ''), items) AS category,
        COALESCE(NULLIF(items, ''), category) AS items,
        quantity,
        amount,
        region
    FROM `buying_data`
    WHERE type = 'Nelayan' AND id_nelayan IS NOT NULL AND name_supplier != ''
),

-- Filtered Data Nelayan with ID and Name Not Null
clean1 AS (
    SELECT * 
    FROM base_table 
    WHERE items != '' AND quantity > 0 AND date_buying >= '2023-07-01' AND amount != 0
    ORDER BY id_nelayan
),

-- Remove Duplicate Entries
clean2 AS (
    SELECT 
        *, 
        ROW_NUMBER() OVER (PARTITION BY id_buying, CAST(quantity AS STRING), category, items ORDER BY date_buying) AS dup
    FROM clean1
),

-- Data Clean From Duplicate Value
clean3 AS (
    SELECT * 
    FROM clean2 
    WHERE dup = 1
),

-- Determine Cohort Data
cohort AS (
    SELECT 
        id_nelayan,
        MIN(date_buying) AS first_buying_date,
        DATE(EXTRACT(YEAR FROM MIN(date_buying)), EXTRACT(MONTH FROM MIN(date_buying)), 1) AS cohort_date
    FROM clean3
    GROUP BY id_nelayan
),

cohort2 AS (
    SELECT 
        cl.*,
        ch.cohort_date,
        EXTRACT(YEAR FROM cl.date_buying) AS buying_year,
        EXTRACT(MONTH FROM cl.date_buying) AS buying_month,
        EXTRACT(YEAR FROM ch.cohort_date) AS cohort_year,
        EXTRACT(MONTH FROM ch.cohort_date) AS cohort_month
    FROM clean3 cl 
    LEFT JOIN cohort ch ON cl.id_nelayan = ch.id_nelayan
),

cohort3 AS (
    SELECT 
        *,
        (EXTRACT(YEAR FROM date_buying) - EXTRACT(YEAR FROM cohort_date)) * 12 +
        (EXTRACT(MONTH FROM date_buying) - EXTRACT(MONTH FROM cohort_date)) + 1 AS cohort_index
    FROM cohort2
)

SELECT * 
FROM cohort3;
