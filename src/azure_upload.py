import io
import os
import pyarrow as pa
import pyarrow.parquet as pq

from azure.storage.blob import BlobServiceClient
from owid import catalog
from datetime import date
from dotenv import load_dotenv

def upload_file_to_blob():

    # Load environment variables
    load_dotenv()

    # Load dataset from OWID Remote Catalog using URL from .env
    remote_catalog = catalog.RemoteCatalog()
    dataset_url = os.getenv("DATASET_URL")
    df = remote_catalog[dataset_url]

    # Convert DataFrame to Parquet and store in memory buffer
    table = pa.Table.from_pandas(df)
    buffer = io.BytesIO()
    pq.write_table(table, buffer)
    buffer.seek(0)

    # Connect to Azure Blob Storage
    connection_string = os.getenv("AZURE_CONNECTION_STRING")
    container_name = os.getenv("BLOB_STORAGE_CONTAINER")
    blob_name = os.getenv("BLOB_NAME")

    # Creating a Blob Client Service
    blob_service_client = BlobServiceClient.from_connection_string(connection_string)

    # Define blob path using today's date
    current_file_date = date.today()
    blob_path = f"{current_file_date}/{blob_name}"

    # Upload the Parquet buffer to Azure Blob Storage
    blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_path)
    blob_client.upload_blob(buffer, overwrite=True)

    print(f"File successfully uploaded to Azure blob storage. Path: {blob_path}")




