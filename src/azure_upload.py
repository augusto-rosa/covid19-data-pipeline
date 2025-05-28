import io
import os
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq

from azure.storage.filedatalake import DataLakeServiceClient
from owid import catalog
from datetime import date
from dotenv import load_dotenv

def upload_file_to_data_lake():
    # Load environment variables
    load_dotenv()

    # Load dataset from OWID catalog
    remote_catalog = catalog.RemoteCatalog()
    dataset_url = os.getenv("DATASET_URL")
    df = remote_catalog[dataset_url]
    df_reset = df.reset_index()

    # Ensuring that the 'date' column is converted to datetime and only the date is kept
    df_reset['date'] = pd.to_datetime(df_reset['date'], errors='coerce').dt.date

    # Convert DataFrame to Parquet and store in memory buffer
    table = pa.Table.from_pandas(df_reset)
    buffer = io.BytesIO()
    pq.write_table(table, buffer)
    buffer.seek(0)

    # Connect to Azure Data Lake
    connection_string = os.getenv("AZURE_CONNECTION_STRING")
    container_name = os.getenv("DATA_LAKE_CONTAINER")
    file_name = os.getenv("DATA_LAKE_NAME")

    # Use today's date as folder name
    dir_name = str(date.today()) 

    # Connect to Azure Data Lake Gen2
    data_lake_service_client = DataLakeServiceClient.from_connection_string(connection_string)
    file_system_client = data_lake_service_client.get_file_system_client(container_name)

    # Get or create the directory where the file will be placed
    directory_client = file_system_client.get_directory_client(dir_name)
    try:
        directory_client.create_directory()
    except Exception:
        pass  # Ignore if directory already exists

    # Create the file and upload the data
    file_client = directory_client.create_file(file_name)
    file_client.append_data(data=buffer.read(), offset=0, length=buffer.getbuffer().nbytes)
    file_client.flush_data(buffer.getbuffer().nbytes)

    print(f"Arquivo '{file_name}' enviado para o Data Lake no caminho '{container_name}/{dir_name}/'.")

