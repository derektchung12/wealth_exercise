{{ config(
    materialized='view'
) }}

WITH source AS (
    SELECT 
        product_id,
        product_name,
        category,
        list_price
    FROM {{ ref('products') }}
),

cleaned AS (
    SELECT
        product_id,
        LOWER(TRIM(product_name)) AS product_name,
        LOWER(TRIM(category)) AS category,
        CAST(list_price AS DECIMAL(10,2)) AS list_price
    FROM source
)

SELECT 
    product_id,
    product_name,
    category,
    list_price
FROM cleaned