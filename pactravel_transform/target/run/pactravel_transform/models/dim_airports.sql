
  
    

  create  table "pactravel_dwh"."final"."dim_airports__dbt_tmp"
  
  
    as
  
  (
    

select 
    airport_id,
    airport_name,
    city,
    latitude,
    longitude
from "pactravel_dwh"."pactravel"."airports"
  );
  