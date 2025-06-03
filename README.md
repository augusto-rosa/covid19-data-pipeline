# COVID-19 Data Pipeline with Microsoft Azure

This project is a fully cloud-based data pipeline built using Microsoft's Azure ecosystem. It ingests COVID-19 data from [Our World in Data](https://ourworldindata.org/coronavirus), processes it through various layers of transformation, and stores the curated data in an Azure SQL Database for visualization in Power BI.

## 🧪 Pipeline Overview

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

📈 Dashboard
Power BI connects directly to the Azure SQL Database and visualizes trends such as annual cases, deaths, and vaccination progress in Canada over time.

![image](https://github.com/user-attachments/assets/452559b9-0e6f-480c-b07b-e7ad9b6254eb)

