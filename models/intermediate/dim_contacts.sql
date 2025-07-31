{{ config(
    materialized='table'
) }}

WITH contacts AS (
    SELECT 
        contact_id,
        first_name,
        last_name,
        email
    FROM {{ ref('stg_contacts') }}
),

order_metrics AS (
    SELECT 
        contact_id,
        COUNT(order_id) AS total_completed_orders,
        SUM(total_amount) AS total_spend,
        AVG(total_amount) AS avg_order_value,
        MIN(order_date) AS first_order_date
    FROM {{ ref('fct_orders') }}
    WHERE order_status = 'completed'
    GROUP BY contact_id
)

SELECT 
    contacts.contact_id,
    contacts.first_name,
    contacts.last_name,
    COALESCE(order_metrics.total_completed_orders, 0) AS total_completed_orders,
    COALESCE(order_metrics.total_spend, 0) AS total_spend,
    order_metrics.avg_order_value,
    CASE 
        WHEN COALESCE(order_metrics.total_completed_orders, 0) > 0 THEN TRUE
        ELSE FALSE
    END AS is_customer,
    CASE 
        WHEN COALESCE(order_metrics.total_completed_orders, 0) > 1 THEN TRUE
        ELSE FALSE
    END AS is_repeat_customer,
    order_metrics.first_order_date AS customer_since_date
FROM contacts
LEFT JOIN order_metrics
    ON contacts.contact_id = order_metrics.contact_id