
  
    

  create  table "pactravel_dwh"."final"."dim_aircrafts__dbt_tmp"
  
  
    as
  
  (
    

select 
    aircraft_id,
    aircraft_name,
    aircraft_iata,
    aircraft_icao
from "pactravel_dwh"."pactravel"."aircrafts"
  );
  