{{ config(
    materialized='view'
) }}

WITH source AS (
    SELECT 
        contact_id,
        first_name,
        last_name,
        email
    FROM {{ ref('contacts') }}
),

cleaned AS (
    SELECT
        contact_id,
        LOWER(TRIM(first_name)) AS first_name,
        LOWER(TRIM(last_name)) AS last_name,
        LOWER(TRIM(email)) AS email
    FROM source
)

SELECT 
    contact_id,
    first_name,
    last_name,
    email
FROM cleaned