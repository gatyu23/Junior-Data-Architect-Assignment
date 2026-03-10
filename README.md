# Surpass - Junior Data Architect Take-Home Assignment

This repository contains an End-to-End data engineering and analytics solution for the Surpass Junior Data Architect assignment. The project demonstrates the extraction, transformation, enrichment, and visualization of vehicle data from the Israeli Ministry of Transport (data.gov.il).

## 🚀 Project Overview
The pipeline processes real-world data and generates a Market Intelligence Dashboard. The workflow consists of four main phases:
1. **API Data Extraction**: Fetching data using pagination and saving it as raw CSV.
2. **DWH Layer & Cleaning**: Loading raw data into PostgreSQL, optimizing data types, handling NULLs, and validating records.
3. **Data Enrichment**: Engineering new features such as Vehicle Age Category, Fuel Classification, and Environmental Pollution Levels.
4. **Market Intelligence Dashboard**: Generating visual business insights using Python (Plotly).

### 💡 Architecture & Scalability
* **Full Local DB**: The core pipeline is designed to handle the full dataset (~4.5 million records) using a local **PostgreSQL** database. 
* **Cloud Demo (Neon)**: To facilitate easy testing and review, a cloud-based PostgreSQL demo (via Neon) is also supported, allowing the visualization notebooks to run out-of-the-box on a sample dataset.

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
