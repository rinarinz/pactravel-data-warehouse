
  
    

  create  table "pactravel_dwh"."final"."dim_airlines__dbt_tmp"
  
  
    as
  
  (
    

select 
    airline_id,
    airline_name,
    country,
    airline_iata,
    airline_icao,
    alias
from "pactravel_dwh"."pactravel"."airlines"
  );
  