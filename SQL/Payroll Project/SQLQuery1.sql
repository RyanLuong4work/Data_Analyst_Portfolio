CREATE SCHEMA LANDING;
CREATE SCHEMA STAGING;
CREATE SCHEMA MARTS;
 
 -- STAGING.stg_allowances
CREATE OR ALTER VIEW staging.stg_allowances AS
WITH source AS (
    SELECT *
    FROM [LANDING].[allowance]
),
allowances_transformed AS (
    SELECT
        allowance_id,
        employee_id,
        allowance_type,
        allowance_amount,
        allowance_start_date,
        allowance_end_date
    FROM source
)
SELECT *
FROM allowances_transformed;

-- STAGING.stg_bonuses
CREATE OR ALTER VIEW staging.stg_bonuses AS
WITH source AS (
    SELECT *
    FROM [LANDING].[bonus]
),
bonuses_transformed AS (
    SELECT
        bonus_id,
        employee_id,
        bonus_type,
        bonus_amount,
        bonus_date
    FROM source
)
SELECT *
FROM bonuses_transformed;

-- STAGING.stg_contracts
CREATE OR ALTER VIEW staging.stg_contracts AS
WITH source AS (
    SELECT *
    FROM [LANDING].[contract_details]
),
contracts_transformed AS (
    SELECT
        contract_id,
        employee_id,
        start_date,
        end_date,
        pay_rate,
        job_title,
        payment_frequency,
        contract_type,
        employment_type,
        contract_status
    FROM source
)
SELECT *
FROM contracts_transformed;


-- STAGING.stg_employee_leaves
CREATE OR ALTER VIEW staging.stg_employee_leaves AS
WITH source AS (
    SELECT *
    FROM [LANDING].[employee_leave]
),
employee_leaves_transformed AS (
    SELECT
        leave_id,
        employee_id,
        leave_type,
        leave_start_date,
        leave_end_date,
        leave_hours
    FROM source
)
SELECT *
FROM employee_leaves_transformed;

-- STAGING.stg_employees
CREATE OR ALTER VIEW staging.stg_employees AS
WITH source AS (
    SELECT *
    FROM [LANDING].[employee_details]
),
employees_transformed AS (
    SELECT
        employee_id,
        employee_first_name,
        employee_middle_name,
        employee_last_name,
        employee_gender,
        employee_location,
        date_of_birth,
        hire_date,
        termination_date,
        employee_status
    FROM source
)
SELECT *
FROM employees_transformed;

-- STAGING.stg_junior_pay_rates
CREATE OR ALTER VIEW staging.stg_junior_pay_rates AS
WITH source AS (
    SELECT *
    FROM [LANDING].[junior_pay_rates]
),
junior_pay_rates_transformed AS (
    SELECT
        CASE
            WHEN age LIKE 'Under 16%' THEN 'JPR15'
            WHEN age LIKE 'At 16%' THEN 'JPR16'
            WHEN age LIKE 'At 17%' THEN 'JPR17'
            WHEN age LIKE 'At 18%' THEN 'JPR18'
            WHEN age LIKE 'At 19%' THEN 'JPR19'
            WHEN age LIKE 'At 20%' THEN 'JPR20'
            ELSE NULL
        END AS pay_rate_id,
        age,
        percent_of_adult_pay_rate
    FROM source
)
SELECT *
FROM junior_pay_rates_transformed;

-- STAGING.stg_minimum_pay_rates
CREATE OR ALTER VIEW staging.stg_minimum_pay_rates AS
WITH source AS (
    SELECT *
    FROM [LANDING].[minimum_pay_rates]
),
minimum_pay_rates_transformed AS (
    SELECT
        pay_rate_id,
        effect_from,
        effect_to,
        hourly_permanent_rate,
        hourly_casual_rate
    FROM source
)
SELECT *
FROM minimum_pay_rates_transformed;

-- STAGING.stg_pay_rate_adjustments
CREATE OR ALTER VIEW staging.stg_pay_rate_adjustments AS
WITH source AS (
    SELECT *
    FROM [LANDING].[pay_rate_adjustments]
),
pay_rate_adjustments_transformed AS (
    SELECT
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            UPPER(rate_type),
            ' ', '_'),
            '-', '_'),
            '(', ''),
            ')', ''),
            '.', ''),
            ',', '') AS pay_rate_id,
        rate_type,
        description,
        rate_calculation
    FROM source
)
SELECT *
FROM pay_rate_adjustments_transformed;

-- STAGING.stg_roster
CREATE OR ALTER VIEW staging.stg_roster AS
WITH source AS (
    SELECT *
    FROM [LANDING].[roster]
),
roster_transformed AS (
    SELECT
        roster_id,
        employee_id,
        shift,
        hours,
        work_date,
        services,
        location,
        pay_period_id
    FROM source
)
SELECT *
FROM roster_transformed;

-- STAGING.stg_tax_rates
CREATE OR ALTER VIEW staging.stg_tax_rates AS
WITH source AS (
    SELECT *
    FROM [LANDING].[tax_rates]
),
tax_rates_transformed AS (
    SELECT
        'TR' +
        REPLACE(REPLACE(REPLACE(year,   '[^0-9]', ''), ' ', ''), '.', '') + '_' +
        REPLACE(REPLACE(REPLACE(start_range, '[^0-9]', ''), ' ', ''), '.', '') + '_' +
        REPLACE(REPLACE(REPLACE(end_range,   '[^0-9]', ''), ' ', ''), '.', '') AS tax_rate_id,
        taxable_income,
        tax_on_this_income,
        year,
        note,
        start_range,
        end_range,
        date_start,
        date_end,
        fixed_tax,
        cumulative_tax
    FROM source
)
SELECT *
FROM tax_rates_transformed;

-- STAGING.stg_time_off_in_lieu
CREATE OR ALTER VIEW staging.stg_time_off_in_lieu AS
WITH source AS (
    SELECT *
    FROM [LANDING].[time_off_in_lieu]
),
time_off_in_lieu_transformed AS (
    SELECT
        toil_id,
        employee_id,
        overtime_date,
        toil_hours_accrued,
        toil_usage_date
    FROM source
)
SELECT *
FROM time_off_in_lieu_transformed;

-- STAGING.stg_timesheet
CREATE OR ALTER VIEW staging.stg_timesheet AS
WITH source AS (
    SELECT *
    FROM [LANDING].[timesheet]
),
timesheet_transformed AS (
    SELECT
        timesheet_id,
        employee_code AS employee_id,
        timesheet_transaction_date,
        start_time,
        end_time,
        timesheet_transaction_hours,
        pay_period_id
    FROM source
)
SELECT *
FROM timesheet_transformed;


-- MARTS.dim_contracts
CREATE OR ALTER VIEW marts.dim_contracts AS
SELECT
    HASHBYTES('SHA1', 
        CONCAT_WS('|',
            CAST(contract_id AS NVARCHAR),
            FORMAT(start_date, 'yyyy-MM-dd HH:mm:ss')  -- Used as a surrogate for dbt_valid_from
        )
    ) AS contract_pk,
    contract_id,
    employee_id,
    start_date,
    end_date,
    pay_rate,
    job_title,
    payment_frequency,
    contract_type,
    employment_type,
    contract_status,
    start_date AS dbt_valid_from,
    end_date AS dbt_valid_to
FROM staging.stg_contracts;

-- MARTS.dim_employees
CREATE OR ALTER VIEW marts.dim_employees AS
SELECT
    HASHBYTES('SHA1', 
        CONCAT_WS('|',
            CAST(employee_id AS NVARCHAR),
            FORMAT(hire_date, 'yyyy-MM-dd HH:mm:ss')  -- Used as surrogate for dbt_valid_from
        )
    ) AS employee_pk,
    employee_id,
    employee_first_name,
    employee_middle_name,
    employee_last_name,
    employee_gender,
    employee_location,
    date_of_birth,
    hire_date,
    termination_date,
    employee_status
FROM staging.stg_employees;

-- MARTS.dim_junior_pay_rates
CREATE OR ALTER VIEW marts.dim_junior_pay_rates AS
SELECT
    pay_rate_id AS pay_rate_pk,
    age,
    percent_of_adult_pay_rate / 100.0 AS adult_pay_rate_multiplier
FROM staging.stg_junior_pay_rates;

---- MARTS.dim_minimum_pay_rates
CREATE OR ALTER VIEW marts.dim_minimum_pay_rates AS
SELECT
    pay_rate_id AS pay_rate_pk,
    effect_from,
    effect_to,
    hourly_permanent_rate,
    hourly_casual_rate
FROM staging.stg_minimum_pay_rates;

-- MARTS.dim_pay_period (full load, materialized as table in dbt)
CREATE OR ALTER VIEW marts.dim_pay_period AS
WITH base AS (
    SELECT
        date,
        pay_period_month,
        pay_period_fortnight,
        pay_period_week,
        calendar_month,
        calendar_month_start_date,
        calendar_month_end_date
    FROM MARTS.dim_dates
),
monthly AS (
    SELECT
        pay_period_month AS pay_period_pk,
        MIN(date) AS period_start_date,
        MAX(date) AS period_end_date,
        DATEADD(DAY, 1, MAX(date)) AS payday,
        'Monthly' AS frequency,
        DATENAME(MONTH, MIN(date)) + ' ' + CAST(YEAR(MIN(date)) AS VARCHAR) AS pay_period_label
    FROM base
    GROUP BY pay_period_month
),
fortnightly AS (
    SELECT
        pay_period_fortnight AS pay_period_pk,
        MIN(date) AS period_start_date,
        MAX(date) AS period_end_date,
        DATEADD(DAY, 1, MAX(date)) AS payday,
        'Fortnightly' AS frequency,
        'Fortnight ' + RIGHT(pay_period_fortnight, 2) + ' ' + DATENAME(MONTH, MIN(date)) + ' ' + CAST(YEAR(MIN(date)) AS VARCHAR) AS pay_period_label
    FROM base
    GROUP BY pay_period_fortnight
),
weekly AS (
    SELECT
        pay_period_week AS pay_period_pk,
        MIN(date) AS period_start_date,
        MAX(date) AS period_end_date,
        DATEADD(DAY, 1, MAX(date)) AS payday,
        'Weekly' AS frequency,
        'Week ' + RIGHT(pay_period_week, 2) + ' ' + DATENAME(MONTH, MIN(date)) + ' ' + CAST(YEAR(MIN(date)) AS VARCHAR) AS pay_period_label
    FROM base
    GROUP BY pay_period_week
)
SELECT * FROM monthly
UNION ALL
SELECT * FROM fortnightly
UNION ALL
SELECT * FROM weekly;

-- MARTS.dim_pay_rate_adjustments
CREATE OR ALTER VIEW marts.dim_pay_rate_adjustments AS
SELECT
    pay_rate_id AS pay_rate_pk,
    rate_type,
    description,
    rate_calculation,
    CASE
        WHEN pay_rate_id = 'CLR' THEN 1.25
        WHEN pay_rate_id = 'NSP' THEN 1.25
        WHEN pay_rate_id = 'ORA' THEN 2.0
        WHEN pay_rate_id = 'ORF' THEN 1.5
        WHEN pay_rate_id = 'ORS' THEN 2.5
        WHEN pay_rate_id = 'PRS' THEN 2.0
        ELSE NULL
    END AS rate_multiplier
FROM staging.stg_pay_rate_adjustments;

-- MARTS.dim_tax_rate
CREATE OR ALTER VIEW marts.dim_tax_rates AS
SELECT
    tax_rate_id AS tax_rate_pk,
    taxable_income,
    tax_on_this_income,
    year,
    note,
    start_range,
    end_range,
    date_start,
    date_end,
    fixed_tax,
    cumulative_tax
FROM staging.stg_tax_rates;

-- MARTS.fact_allowances
CREATE OR ALTER VIEW marts.fact_allowances AS
WITH allowances AS (
    SELECT *
    FROM staging.stg_allowances
),
employees AS (
    SELECT *
    FROM marts.dim_employees
),
contracts AS (
    SELECT *
    FROM marts.dim_contracts
),
dates AS (
    SELECT
        date,
        pay_period_week,
        pay_period_fortnight,
        pay_period_month
    FROM MARTS.dim_dates
),
allowances_joined AS (
    SELECT
        a.allowance_id AS allowance_pk,
        e.employee_pk AS employee_fk,
        c.contract_pk AS contract_fk,
        a.allowance_type,
        a.allowance_amount,
        a.allowance_start_date,
        a.allowance_end_date,
        CONVERT(INT, FORMAT(a.allowance_start_date, 'yyyyMMdd')) AS allowance_start_date_fk,
        CONVERT(INT, FORMAT(a.allowance_end_date, 'yyyyMMdd')) AS allowance_end_date_fk,
        CASE
            WHEN LOWER(c.payment_frequency) = 'weekly' THEN d.pay_period_week
            WHEN LOWER(c.payment_frequency) = 'fortnightly' THEN d.pay_period_fortnight
            WHEN LOWER(c.payment_frequency) = 'monthly' THEN d.pay_period_month
            ELSE NULL
        END AS pay_period_fk
    FROM allowances a
    LEFT JOIN employees e
        ON a.employee_id = e.employee_id
    LEFT JOIN contracts c
        ON a.employee_id = c.employee_id
        AND a.allowance_start_date BETWEEN c.start_date AND ISNULL(c.end_date, '9999-12-31')
    LEFT JOIN dates d
        ON a.allowance_start_date = d.date
)
SELECT *
FROM allowances_joined;

-- MARTS.fact_bonuses
CREATE OR ALTER VIEW marts.fact_bonuses AS
WITH bonuses AS (
    SELECT *
    FROM staging.stg_bonuses
),
employees AS (
    SELECT *
    FROM marts.dim_employees
),
contracts AS (
    SELECT *
    FROM marts.dim_contracts
),
dates AS (
    SELECT
        date,
        pay_period_week,
        pay_period_fortnight,
        pay_period_month
    FROM marts.dim_dates
),
bonuses_joined AS (
    SELECT
        b.bonus_id AS bonus_pk,
        e.employee_pk AS employee_fk,
        c.contract_pk AS contract_fk,
        b.bonus_type,
        b.bonus_amount,
        b.bonus_date,
        CONVERT(INT, FORMAT(b.bonus_date, 'yyyyMMdd')) AS bonus_date_fk,
        CASE
            WHEN LOWER(c.payment_frequency) = 'weekly' THEN d.pay_period_week
            WHEN LOWER(c.payment_frequency) = 'fortnightly' THEN d.pay_period_fortnight
            WHEN LOWER(c.payment_frequency) = 'monthly' THEN d.pay_period_month
            ELSE NULL
        END AS pay_period_fk
    FROM bonuses b
    LEFT JOIN employees e
        ON b.employee_id = e.employee_id
    LEFT JOIN contracts c
        ON b.employee_id = c.employee_id
        AND b.bonus_date BETWEEN c.start_date AND ISNULL(c.end_date, '9999-12-31')
    LEFT JOIN dates d
        ON b.bonus_date = d.date
)
SELECT *
FROM bonuses_joined;

-- MARTS.fact_employee_leaves (full load view)
CREATE OR ALTER VIEW marts.fact_employee_leaves AS
WITH employee_leaves AS (
    SELECT *
    FROM staging.stg_employee_leaves
),
employees AS (
    SELECT *
    FROM marts.dim_employees
),
contracts AS (
    SELECT *
    FROM marts.dim_contracts
),
dates AS (
    SELECT
        date,
        pay_period_week,
        pay_period_fortnight,
        pay_period_month
    FROM marts.dim_dates
),
employee_leaves_joined AS (
    SELECT
        l.leave_id AS leave_pk,
        e.employee_pk AS employee_fk,
        c.contract_pk AS contract_fk,
        l.leave_type,
        l.leave_start_date,
        l.leave_end_date,
        CONVERT(INT, FORMAT(l.leave_start_date, 'yyyyMMdd')) AS leave_start_date_fk,
        CONVERT(INT, FORMAT(l.leave_end_date, 'yyyyMMdd')) AS leave_end_date_fk,
        l.leave_hours,
        CASE
            WHEN LOWER(c.payment_frequency) = 'weekly' THEN d.pay_period_week
            WHEN LOWER(c.payment_frequency) = 'fortnightly' THEN d.pay_period_fortnight
            WHEN LOWER(c.payment_frequency) = 'monthly' THEN d.pay_period_month
            ELSE NULL
        END AS pay_period_fk
    FROM employee_leaves l
    LEFT JOIN employees e
        ON l.employee_id = e.employee_id
    LEFT JOIN contracts c
        ON l.employee_id = c.employee_id
        AND l.leave_start_date BETWEEN c.start_date AND ISNULL(c.end_date, '9999-12-31')
    LEFT JOIN dates d
        ON l.leave_start_date = d.date
)
SELECT *
FROM employee_leaves_joined;

-- MARTS.fact_roster (full load view)
CREATE OR ALTER VIEW marts.fact_roster AS
WITH roster AS (
    SELECT *
    FROM staging.stg_roster
),
employees AS (
    SELECT *
    FROM marts.dim_employees
),
contracts AS (
    SELECT *
    FROM marts.dim_contracts
),
dates AS (
    SELECT
        date,
        pay_period_week,
        pay_period_fortnight,
        pay_period_month
    FROM marts.dim_dates
),
roster_joined AS (
    SELECT
        r.roster_id AS roster_pk,
        e.employee_pk AS employee_fk,
        c.contract_pk AS contract_fk,
        r.shift,
        r.hours,
        r.work_date,
        CONVERT(INT, FORMAT(r.work_date, 'yyyyMMdd')) AS work_date_fk,
        r.services,
        r.location,
        CASE
            WHEN LOWER(c.payment_frequency) = 'weekly' THEN d.pay_period_week
            WHEN LOWER(c.payment_frequency) = 'fortnightly' THEN d.pay_period_fortnight
            WHEN LOWER(c.payment_frequency) = 'monthly' THEN d.pay_period_month
            ELSE NULL
        END AS pay_period_fk
    FROM roster r
    LEFT JOIN employees e
        ON r.employee_id = e.employee_id
    LEFT JOIN contracts c
        ON r.employee_id = c.employee_id
        AND r.work_date BETWEEN c.start_date AND ISNULL(c.end_date, '9999-12-31')
    LEFT JOIN dates d
        ON r.work_date = d.date
)
SELECT *
FROM roster_joined;

-- MARTS.fact_time_off_in_lieu (full load view)
CREATE OR ALTER VIEW marts.fact_time_off_in_lieu AS
WITH time_off_in_lieu AS (
    SELECT *
    FROM staging.stg_time_off_in_lieu
),
employees AS (
    SELECT *
    FROM marts.dim_employees
),
contracts AS (
    SELECT *
    FROM marts.dim_contracts
),
dates AS (
    SELECT
        date,
        pay_period_week,
        pay_period_fortnight,
        pay_period_month
    FROM marts.dim_dates
),
time_off_in_lieu_joined AS (
    SELECT
        t.toil_id AS toil_pk,
        e.employee_pk AS employee_fk,
        c.contract_pk AS contract_fk,
        t.overtime_date,
        CONVERT(INT, FORMAT(t.overtime_date, 'yyyyMMdd')) AS overtime_date_fk,
        t.toil_hours_accrued,
        t.toil_usage_date,
        CONVERT(INT, FORMAT(t.toil_usage_date, 'yyyyMMdd')) AS toil_usage_date_fk,
        CASE
            WHEN LOWER(c.payment_frequency) = 'weekly' THEN d.pay_period_week
            WHEN LOWER(c.payment_frequency) = 'fortnightly' THEN d.pay_period_fortnight
            WHEN LOWER(c.payment_frequency) = 'monthly' THEN d.pay_period_month
            ELSE NULL
        END AS pay_period_fk
    FROM time_off_in_lieu t
    LEFT JOIN employees e
        ON t.employee_id = e.employee_id
    LEFT JOIN contracts c
        ON t.employee_id = c.employee_id
        AND t.overtime_date BETWEEN c.start_date AND ISNULL(c.end_date, '9999-12-31')
    LEFT JOIN dates d
        ON t.overtime_date = d.date
)
SELECT *
FROM time_off_in_lieu_joined;

-- MARTS.fact_time_sheet (full-load view with join logic)
CREATE OR ALTER VIEW marts.fact_time_sheet AS
WITH timesheet AS (
    SELECT *
    FROM staging.stg_timesheet
),
employees AS (
    SELECT *
    FROM marts.dim_employees
),
contracts AS (
    SELECT *
    FROM marts.dim_contracts
),
dates AS (
    SELECT
        [date],
        pay_period_week,
        pay_period_fortnight,
        pay_period_month
    FROM marts.dim_dates
),
timesheet_joined AS (
    SELECT
        t.timesheet_id AS timesheet_pk,
        e.employee_pk AS employee_fk,
        c.contract_pk AS contract_fk,
        t.timesheet_transaction_date,
        CONVERT(INT, FORMAT(t.timesheet_transaction_date, 'yyyyMMdd')) AS timesheet_transaction_date_fk,
        t.start_time,
        t.end_time,
        t.timesheet_transaction_hours,
        CASE
            WHEN LOWER(c.payment_frequency) = 'weekly' THEN d.pay_period_week
            WHEN LOWER(c.payment_frequency) = 'fortnightly' THEN d.pay_period_fortnight
            WHEN LOWER(c.payment_frequency) = 'monthly' THEN d.pay_period_month
            ELSE NULL
        END AS pay_period_fk
    FROM timesheet t
    LEFT JOIN employees e
        ON t.employee_id = e.employee_id
    LEFT JOIN contracts c
        ON t.employee_id = c.employee_id
        AND t.timesheet_transaction_date BETWEEN c.start_date AND ISNULL(c.end_date, '9999-12-31')
    LEFT JOIN dates d
        ON t.timesheet_transaction_date = d.date
)
SELECT *
FROM timesheet_joined;