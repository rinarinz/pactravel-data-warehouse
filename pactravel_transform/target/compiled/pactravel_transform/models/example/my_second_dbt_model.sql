-- Use the `ref` function to select from other models

select *
from "pactravel_dwh"."final"."my_first_dbt_model"
where id = 1