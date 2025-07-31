{{ config(
    materialized='view'
) }}

WITH source AS (
    SELECT 
        order_item_id,
        order_id,
        product_id,
        quantity
    FROM {{ ref('order_items') }}
),

cleaned AS (
    SELECT
        order_item_id,
        order_id,
        product_id,
        CAST(quantity AS INTEGER) AS quantity
    FROM source
)

SELECT 
    order_item_id,
    order_id,
    product_id,
    quantity
FROM cleaned