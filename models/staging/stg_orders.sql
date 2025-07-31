{{ config(
    materialized='view'
) }}

WITH source AS (
    SELECT 
        order_id,
        contact_id,
        order_date,
        status,
        total_amount
    FROM {{ ref('orders') }}
),

cleaned AS (
    SELECT
        order_id,
        contact_id,
        CAST(order_date AS TIMESTAMP) AS order_date,
        LOWER(TRIM(status)) AS order_status,
        CAST(total_amount AS DECIMAL(10,2)) AS total_amount
    FROM source
)

SELECT 
    order_id,
    contact_id,
    order_date,
    order_status,
    total_amount
FROM cleaned