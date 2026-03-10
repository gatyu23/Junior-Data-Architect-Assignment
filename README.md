# Junior Data Architect Assignment

This repository contains an **end-to-end data engineering and analytics solution** for the Surpass Junior Data Architect assignment.  
The project demonstrates the **extraction, transformation, enrichment, and visualization** of vehicle data from the Israeli Ministry of Transport dataset available on **data.gov.il**.

---

# Project Overview

The pipeline processes real-world transportation data and generates a **Market Intelligence Dashboard**.

The workflow consists of four main phases:

1. **API Data Extraction**  
   Fetching raw data from the government API using pagination and storing it as CSV.

2. **Data Warehouse (DWH) Layer & Cleaning**  
   Loading raw data into PostgreSQL, optimizing data types, handling NULL values, and validating records.

3. **Data Enrichment**  
   Engineering new analytical features such as:
   - Vehicle Age Category
   - Fuel Classification
   - Environmental Pollution Levels

4. **Market Intelligence Dashboard**  
   Generating visual insights using **Python and Plotly**.

---

# 💡 Architecture & Scalability

To ensure robustness and ease of review, the project includes **two pipeline environments**.

### 1️⃣ Full Local Environment (Production Scale)

The core pipeline runs on a **local PostgreSQL database**.

This setup processes the **entire dataset (~4.5 million records)** and demonstrates the architecture's ability to handle large-scale data workloads without the storage limitations of free cloud tiers.

### 2️⃣ Cloud Demo Environment (Neon DB)

Due to storage limitations of the free **Neon PostgreSQL cloud tier**, a parallel cloud demo pipeline was created.

This version:

- Extracts a **representative sample** of the dataset directly via API
- Loads the data into **Neon Cloud PostgreSQL**
- Allows reviewers to **run the notebooks instantly without local setup**

This approach ensures **both scalability and ease of evaluation**.

---

# 📁 Repository Structure
/
├── notebooks/
│   ├── Vehicle_Data_Pipeline_&_Insights.ipynb
│   │     API extraction + end-to-end pipeline
│   │
│   └── Market_Intelligence_Full_Analysis.ipynb
│         Visualization & dashboard generation (Full Dataset)
│
├── sql/
│   ├── dwh_schema.sql
│   │     Schema creation and optimized data types
│   │
│   ├── dwh_procedure.sql
│   │     Data cleaning and loading logic
│   │
│   └── enrich_dwh.sql
│         Feature engineering and indexing
│
├── charts/
│   ├── Market Share Analysis.png
│   ├── Fleet Age Distribution.png
│   ├── Environmental Trend.png
│   └── Fuel distribution by 5-year periods.png
│
├── data/
│   └── enrichment_validation.csv
│         Validation statistics of enriched fields
│
└── README.md

---

## 🛠️ Prerequisites & Setup

To run this project locally, ensure you have the following installed:

* **Python 3.8+**
* **PostgreSQL**
* Python packages: `pandas`, `requests`, `sqlalchemy`, `plotly`, `psycopg2`

---

## ⚙️ How to Run

1. **Cloud Demo (Fastest Way)**  
   Simply open and run all cells in `Vehicle_Data_Pipeline_&_Insights.ipynb`.  
   It connects to the Neon cloud DB and displays the pipeline logic and dashboard immediately.

2. **Local Database Setup (Full Data)**  
   To process the entire dataset locally, execute the SQL scripts in the `sql/` folder sequentially:

   ```
   dwh_schema.sql → dwh_procedure.sql → enrich_dwh.sql
   ```

3. **Generate Full Dashboard**  
   Run `Market_Intelligence_Full_Analysis.ipynb` to connect to your local database, analyze the ~4.5 million enriched records, and generate the final business insights.

---
## 📌 Key Assumptions & Data Logic

During the cleaning and enrichment phases, the following business logic was applied:

* **Production Year Validation**  
  Filtered valid production years between `1900` and `2026`. Outliers and anomalies were treated as `NULL`.

* **Missing Values Handling**  
  Empty strings (`""`) and textual `"null"` values from the raw API were converted to proper SQL `NULL` values.

* **Vehicle Age Calculation**  
  Calculated relative to the assignment's baseline year (2026).

* **Fuel Categorization**  
  Clustered various raw fuel descriptions into distinct macro-categories (e.g., Gasoline, Diesel, Hybrid, Electric) for cleaner visualization.

* **Manufacturer Region Logic**  
  `manufacturer_region` was derived based on the **brand's country/region of origin** rather than the actual vehicle manufacturing country.

* **Road Registration Date Standardization**  
  The `moed_aliya_lakvish` field was provided in **month/year format** only.  
  In order to convert it into a standard SQL `DATE` format, all vehicles were assigned the **first day of the reported month**.

  ---
 

## 📊 Dashboard Preview

Below are key insights generated from the enriched vehicle dataset (~4.5M records).

| Market Share | Fleet Age |
|--------------|-----------|
| <img src="charts/Market Share Analysis.png" width="500"> | <img src="charts/Fleet Age Distribution.png" width="500"> |

| Pollution Trend | Fuel Evolution |
|-----------------|---------------|
| <img src="charts/Environmental Trend.png" width="500"> | <img src="charts/Fuel distribution by 5-year periods.png" width="500"> |
