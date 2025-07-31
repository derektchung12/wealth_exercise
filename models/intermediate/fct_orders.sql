{{ config(
    materialized='table'
) }}

WITH orders AS (
    SELECT 
        order_id,
        contact_id,
        order_date,
        order_status,
        total_amount
    FROM {{ ref('stg_orders') }}
),

order_items AS (
    SELECT 
        order_id,
        product_id,
        quantity
    FROM {{ ref('stg_order_items') }}
),

products AS (
    SELECT 
        product_id,
        list_price
    FROM {{ ref('stg_products') }}
),

order_aggregates AS (
    SELECT 
        order_items.order_id,
        SUM(order_items.quantity) AS total_quantity,
        SUM(order_items.quantity * products.list_price) AS list_amount
    FROM order_items
    LEFT JOIN products
        ON order_items.product_id = products.product_id
    GROUP BY order_items.order_id
)

SELECT 
    orders.order_id,
    orders.contact_id,
    orders.order_date,
    orders.order_status,
    orders.total_amount,
    COALESCE(order_aggregates.total_quantity, 0) AS total_quantity,
    COALESCE(order_aggregates.list_amount, 0) AS list_amount,
    CASE 
        WHEN orders.total_amount < COALESCE(order_aggregates.list_amount, 0) THEN TRUE
        ELSE FALSE
    END AS is_discount_applied
FROM orders
LEFT JOIN order_aggregates
    ON orders.order_id = order_aggregates.order_id