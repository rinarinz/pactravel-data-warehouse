{{ config(materialized='table') }}

select 
    aircraft_id,
    aircraft_name,
    aircraft_iata,
    aircraft_icao
from {{ source('pactravel', 'aircrafts') }}