✈️ PacTravel Data Warehouse & ELT Pipeline Project

Step #1 - Requirements Gathering 
Description of Data Source
The primary data is sourced from the PacTravel operational system, which encompasses a comprehensive travel ecosystem:

Master Data: Consists of information regarding customers, airlines, hotels, airports, and aircraft fleets.

Transactional Data: Separate booking records for flight tickets (flight_bookings) and hotel reservations (hotel_bookings).

Format & Context: Data is stored in a PostgreSQL relational format. The main challenge lies in the fragmented data structure, necessitating an integration process to produce comprehensive analytical reports.

Problem
PacTravel stakeholders currently face challenges in:

Data Fragmentation: Hotel and flight transaction information reside in different tables, preventing a holistic view of daily business performance.

Lack of Integrated Analysis: The absence of an automated system to monitor ticket price fluctuations and booking volumes across routes in real-time.

Solution
Developing a Data Warehouse infrastructure using a Star Schema and an ELT (Extract, Load, Transform) pipeline. This pipeline will unify raw data into dimension and fact tables that are ready for complex analytical queries.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Step #2 - Designing Data Warehouse Model 
Dimensional Model Process
Select Business Process: Order Transaction (Travel service booking process).

Declare Grain:

1. Atomic Level: Each row represents a single product transaction (flight/hotel) by a customer.

2. Aggregate Level: Each row represents the total daily transactions for each product category.

Identify The Dimensions:
dim_customers, dim_hotels, dim_airlines, dim_airports, dim_aircrafts.

Identify The Facts:
In this design, two types of fact tables are used to meet different analytical needs:

1. fct_order_transaction (Transaction Fact Table): Stores every transaction detail at a granular level. Used for deep analysis such as airport route performance or aircraft fleet efficiency.

2. fct_daily_total (Aggregated Fact Table): Stores daily summaries. This table is designed to accelerate executive reporting performance regarding revenue trends and transaction volumes without processing millions of detailed records every time.

SCD Strategy:
Implementing SCD (Slowly Changing Dimension) Type 2 on the customer dimension (dim_customers) to track data change history (e.g., changes in domicile), ensuring that historical data integrity in the fact tables remains accurate.

Data Warehouse Diagram: ERD

### **ERD (Entity Relationship Diagram)**
![ERD Star Schema](ERD.png)

Figure 1: Star Schema visualization in DBeaver. 
The central fact table connects to all dimensions via 6 Virtual Foreign Key paths.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Step #3 - Data Pipeline Implementation 
Workflow
This pipeline implements a modern ELT workflow:

1. Extract & Load: Data is extracted from the operational database and loaded into the staging schema in the Data Warehouse using Python (main.py) running within a Docker environment.

2. Transform: Utilizing dbt (data build tool) to process data from staging to the final schema.

3. Process: Data type cleansing (specifically handling aircraft IDs containing strings), data unification (UNION ALL), and attribute denormalization (such as including origin and destination city names directly in the fact table).

4. Scheduling & Alerting
Scheduling: Currently executed manually via the dbt CLI. This architecture is ready to be scheduled using Apache Airflow or GitHub Actions for production automation.

5.Alerting: Data quality checks are integrated within dbt logs. A failure in any model will automatically stop downstream processes to prevent data inconsistency.

Code Repository Structure
Primary transformation folder: /pactravel_transform
Validation analysis queries: /pactravel_transform/analyses/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Step #4 - Show Results of the Pipeline 
1. Successful dbt Execution (PASS=7)
The pipeline execution shows that all 7 models (5 dimensions and 2 facts) were created perfectly.

2. Data Validation Results via SQL Scripts
To prove the pipeline operates according to business requirements, several validation queries were executed using SQL files stored in the analyses folder:

Route Verification & Dimension Join (analyses/check_flight_origin_destination_data.sql):
This script ensures the fact table successfully retrieved city names from dim_airports.

### **Flight Routes Validation Result**
![Route Analysis Result](check_origin_destination_data.png)

Figure 2: Route validation results. 
City names for origin and destination appear correctly for the 'flight' type.

Daily Volume Verification (analyses/check_daily_volume.sql):
Ensures that data in fct_daily_total has been accurately aggregated per day.


### **Daily Revenue Result Validation**
![Daily Total Result](daily_total_result.png)
Figure 3: Daily revenue summary for monitoring business performance.

Price & Provider Analysis (analyses/check_pricing_analysis.sql):
Used to monitor average prices across service providers (airlines/hotels).

### **dbt Execution Result (PASS=7)**
![dbt Run Result](order_transaction_result.png)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
This report serves as complete documentation of the PacTravel Data Warehouse development process. All scripts, dbt models, and visual assets are available in this repository for further verification.

🚀 How to Run the Pipeline
Preparation: Ensure Docker is running.

Replicate Database: Run ```docker-compose up -d```

Initiate Data: Run ```python main.py```

Transform Data:
```
cd pactravel_transform
python -m dbt.cli.main run
```
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# PACTRAVEL - ELT Pipeline Orhcestration For Exercise 3
## How to use this Data?
1. Requirements
2. Preparations

### 1. Requirements
- Tools :
    - Dbeaver/SQL Client
    - Docker

### 2. Preparations
- **Clone repo** :
  ```
  # Clone
  git clone [repo_link]
  ```
- **Create .env file** in project root directory :
  ```
    # Source
    SRC_POSTGRES_DB=pactravel   ----->change into "pactravel_src"
    SRC_POSTGRES_HOST=localhost
    SRC_POSTGRES_USER=postgres
    SRC_POSTGRES_PASSWORD=mypassword
    SRC_POSTGRES_PORT=5433

    # DWH
    DWH_POSTGRES_DB=pactravel-dwh ----->change into "pactravel_dwh"
    DWH_POSTGRES_HOST=localhost
    DWH_POSTGRES_USER=postgres
    DWH_POSTGRES_PASSWORD=mypassword
    DWH_POSTGRES_PORT=5434
    ```


- **Run Data Sources & Data Warehouses** :
  ```
  docker compose up -d
  ```

- **Dataset**
    - Source: Pactravel
    - DWH:
        - staging schema: pactravel
        - final schema: final
