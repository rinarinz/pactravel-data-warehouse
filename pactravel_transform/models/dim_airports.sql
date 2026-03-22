{{ config(materialized='table') }}

select 
    airport_id,
    airport_name,
    city,
    latitude,
    longitude
from {{ source('pactravel', 'airports') }}