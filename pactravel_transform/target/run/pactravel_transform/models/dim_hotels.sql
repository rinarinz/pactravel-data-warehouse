
  
    

  create  table "pactravel_dwh"."final"."dim_hotels__dbt_tmp"
  
  
    as
  
  (
    

select 
    hotel_id,
    hotel_name,
    hotel_address,
    city,
    country,
    hotel_score
from "pactravel_dwh"."pactravel"."hotel"
  );
  