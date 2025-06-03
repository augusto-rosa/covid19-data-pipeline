# 🦠 COVID-19 Data Pipeline End To End with Microsoft Azure

This project is a fully cloud-based data pipeline built using Microsoft's Azure ecosystem. It ingests COVID-19 data from [Our World in Data](https://ourworldindata.org/coronavirus), processes it through various layers of transformation, and stores the curated data in an Azure SQL Database for visualization in Power BI.

## 🧭 Architecture Overview
![end-to-end-covid19-pandemic](https://github.com/user-attachments/assets/c9bcaa0a-ca43-4489-8992-459972b12bc4)

## 🧪 Pipeline Overview
```
Python API Our World in Data
↓

Azure Data Lake Gen2 (parquet)
↓

Synapse Serverless - VIEW bronze.covid19data
↓

Synapse Serverless - VIEW silver.tables (SQL transformations)
↓

Azure Data Factory - Loop + Copy Activity
↓

Azure SQL Database (gold.tables)
↓

Power BI - Direct connection to Azure SQL Database
```
## 🔄 Azure Data Factory Pipeline (ETL Flow)

Below is a screenshot of the ADF pipeline that orchestrates the data movement and transformation process:

![adf_pipeline](https://github.com/user-attachments/assets/c71c1083-9d41-4961-bf05-42e0cfee2c80)

This pipeline performs the following steps:
1. **Lookup Views**: Reads metadata about views to be processed.
2. **Set Variable**: Dynamically assigns view names.
3. **ForEach Loop**: Iterates over each view and runs the copy activity.
4. **Copy Activity**: Transfers data from Silver Layer to Gold Layer in Azure SQL.

All activities are executed dynamically and succeeded during testing.

## 🔍 Why I Built This Project

The main motivation for this project was to gain hands-on experience building a real-world, end-to-end data pipeline in the cloud. I wanted to simulate an actual enterprise-grade data flow using modern tools, with special attention to performance, cost-efficiency, and maintainability.

COVID-19 data was chosen because it's publicly available, updated daily, and offers a rich variety of metrics across different countries and dates—perfect for testing time-series transformations, incremental loads, and business intelligence use cases.

## 📊 Why Our World in Data?

[Our World in Data](https://ourworldindata.org/coronavirus) offers a comprehensive, reliable, and well-documented API for COVID-19 data. It's maintained by a reputable academic institution and includes detailed information about cases, deaths, testing, vaccinations, and more, covering all countries globally. This makes it an ideal data source for building a globally applicable analytics solution.

## 🛠️ Why Microsoft Azure?

I chose the Microsoft Azure ecosystem for the following reasons:

- **Hands-on Experience**: Working with Azure services such as Synapse, Data Factory, and Data Lake allowed me to practice skills in high demand in the industry.
- **Cost-Effectiveness**: Services like Synapse Serverless and Azure SQL Database offer great performance at a low cost, making them suitable for individual projects.
- **End-to-End Solution**: Azure offers all components needed to build a complete pipeline—from ingestion and storage to transformation and visualization—within the same environment.
- **Real-World Relevance**: The design and tools mirror those used in professional data engineering teams, making the project experience as close as possible to enterprise use cases.

## 🚀 Technologies Used

- **Python** – For extracting data from the API and writing to Azure Data Lake Gen2
- **Azure Data Lake Gen2** – Raw and curated data storage in Parquet format
- **Azure Synapse Analytics (Serverless)** – SQL views for bronze and silver layer transformations
- **Azure Data Factory** – Orchestrating data movement and copy operations
- **Azure SQL Database** – Gold layer tables for serving data to Power BI
- **Power BI** – Reporting and data visualization

## 📁 Project Structure

```bash
.
├── pipeline/
│   ├── ingestion/
│   ├── transformation/
│   └── utils/
├── notebooks/
├── powerbi/
├── data/
└── README.md
```

## 📈 Dashboard
Power BI connects directly to the Azure SQL Database and visualizes trends such as annual cases, deaths, and vaccination progress in Canada over time.

## 🧠 Key Metrics Presented
**Total Confirmed Cases & Deaths**

**Vaccination Progress (%)**

**Annual Case Trends**

**Covid-19 Tests**

**Hospitalization and ICU Rates Over Time**

The interactive dashboard allows the user to filter and drill down into data per year, month, or date group, which facilitates deeper insights into the evolution of the pandemic in Canada.

![image](https://github.com/user-attachments/assets/452559b9-0e6f-480c-b07b-e7ad9b6254eb)

## 🧱 Data Model Overview
To support the dashboard visuals, a dimensional data model was designed using the star schema approach. This consists of fact and dimension tables linked by primary and foreign keys, enabling optimized queries and performance in Power BI.

![tables_power_bi](https://github.com/user-attachments/assets/6125f803-f4c2-44e3-bff2-6017ed6d31b7)

## ✅ Conclusion and Learnings
This project helped reinforce important concepts in data modeling, ETL, and interactive dashboard creation. By connecting Power BI to an Azure SQL Database, the entire flow from raw data ingestion to actionable insights was demonstrated.

Potential future improvements include:

Adding international comparisons (e.g., USA, BR).

Including demographic breakdowns such as gender or income groups.

Automating data refreshes via Azure Data Factory.

This end-to-end solution is a practical example of using modern cloud-based BI tools to tackle real-world public health challenges.

