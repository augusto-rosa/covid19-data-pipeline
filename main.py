import io
import os
import pyarrow as pa
import pyarrow.parquet as pq
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient, BlobClient
from owid import catalog
from datetime import date

# Use a URI to load the dataset below
rc = catalog.RemoteCatalog()
uri = "garden/covid/latest/compact/compact" #Consigo chamar um dataset especifico com base na URL
df = rc[uri]

# Converts DataFrame to Parquet table
table = pa.Table.from_pandas(df)
buffer = io.BytesIO()
pq.write_table(table, buffer)
buffer.seek(0)

# Creating a Client Object
conection_string = "DefaultEndpointsProtocol=https;AccountName=blobcontainercovid19;AccountKey=yz3VuTcbLoVlYYqNgutA+QqDI+EzHnJhSE6vYgNlrrhgXXUtCfVMN1ZfMTJmUNlElobWhRVBFWnH+ASt7oMZYA==;EndpointSuffix=core.windows.net"

blob_service_client = BlobServiceClient.from_connection_string(conection_string)

container_name = "covid19-raw-data"
current_file_date = date.today()
blob_file_Name = f"{current_file_date}/owid-covid-data.parquet"


# Client object
blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_file_Name) #Tentar chamar a data aqui depois

# Upload file
blob_client.upload_blob(buffer, overwrite=True)

print(f"File sent as {blob_file_Name}")




