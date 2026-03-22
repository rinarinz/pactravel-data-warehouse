{{ config(materialized='table') }}

select 
    airline_id,
    airline_name,
    country,
    airline_iata,
    airline_icao,
    alias
from {{ source('pactravel', 'airlines') }}