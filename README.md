# Junior Data Architect Assignment

This repository contains an End-to-End data engineering and analytics solution for the Surpass Junior Data Architect assignment. The project demonstrates the extraction, transformation, enrichment, and visualization of vehicle data from the Israeli Ministry of Transport (data.gov.il).

## 🚀 Project Overview
The pipeline processes real-world data and generates a Market Intelligence Dashboard. The workflow consists of four main phases:
1. **API Data Extraction**: Fetching data using pagination and saving it as raw CSV.
2. **DWH Layer & Cleaning**: Loading raw data into PostgreSQL, optimizing data types, handling NULLs, and validating records.
3. **Data Enrichment**: Engineering new features such as Vehicle Age Category, Fuel Classification, and Environmental Pollution Levels.
4. **Market Intelligence Dashboard**: Generating visual business insights using Python (Plotly).

   
### 💡 Architecture & Scalability
To ensure both robustness and ease of review, I have implemented two identical versions of the data pipeline:

* **Full Local Environment (Production Scale)**: The core pipeline is configured to run on a local **PostgreSQL** database. This setup is designed to process the entire dataset of approximately 4.5 million records, demonstrating the architecture's ability to handle large-scale data without being restricted by the storage limitations of free cloud tiers.
* **Cloud Demo Environment (Neon DB)**: Due to the storage constraints of the free Neon cloud database, I deployed a parallel, ready-to-run cloud version. This version extracts a representative sample of the data directly via the API and stores it in Neon. It is specifically designed to allow reviewers to easily execute the notebooks and evaluate the dashboard logic out-of-the-box, without needing to set up or configure a local database.
## 📁 Repository Structure

```text
/
├── notebooks/
│   ├── Vehicle_Data_Pipeline_&_Insights.ipynb    # API extraction and full end-to-end pipeline
│   └── Market_Intelligence_Full_Analysis.ipynb   # Visualization & dashboard generation (Local/Full DB)
├── sql/
│   ├── dwh_schema.sql                            # DDL for schema and optimized data types
│   ├── dwh_procedure.sql                         # Data cleaning and loading logic
│   └── enrich_dwh.sql                            # Feature engineering and indexing
├── charts/                                       # High-resolution PNG files (Full Dataset)
│   ├── chart_market_share.png
│   ├── chart_fleet_age.png
│   ├── chart_pollution_trend.png
│   └── chart_fuel_evolution.png
├── data/
│   └── enrichment_validation.csv                 # Statistics and validation of enriched fields
└── README.md


## 🛠️ Prerequisites & Setup
To run this project locally, ensure you have the following installed:
* **Python 3.8+**
* **PostgreSQL**
* Python packages: `pandas`, `requests`, `sqlalchemy`, `plotly`, `psycopg2`

### Environment Variables
For security reasons, database credentials are not hardcoded. Please set the following environment variables (or update the connection strings locally in the notebooks):
* `DB_HOST`
* `DB_PORT`
* `DB_NAME`
* `DB_USER`
* `DB_PASS`

## ⚙️ How to Run
1. **Cloud Demo (Fastest Way)**: Simply open and run all cells in `Vehicle_Data_Pipeline_&_Insights.ipynb`. It connects to the Neon cloud DB and displays the pipeline logic and dashboard immediately.
2. **Local Database Setup (Full Data)**: To process the entire dataset locally, execute the SQL scripts in the `sql/` folder sequentially (`dwh_schema.sql` -> `dwh_procedure.sql` -> `enrich_dwh.sql`) in your PostgreSQL environment.
3. **Generate Full Dashboard**: Run `Market_Intelligence_Full_Analysis.ipynb` to connect to your local database, analyze the ~4.5 million enriched records, and generate the final business insights.

## 📌 Key Assumptions & Data Logic
During the cleaning and enrichment phases, the following business logic was applied:
* **Production Year Validation**: Filtered valid production years between `1900` and `2026`. Outliers and anomalies were treated as `NULL`.
* **Missing Values Handling**: Empty strings (`""`) and textual `"null"` values from the raw API were converted to proper SQL `NULL` values.
* **Vehicle Age Calculation**: Calculated relative to the assignment's baseline year (2026).
* **Fuel Categorization**: Clustered various raw fuel descriptions into distinct macro-categories (e.g., Gasoline, Diesel, Hybrid, Electric) for cleaner visualization.
