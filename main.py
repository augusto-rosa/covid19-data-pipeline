from src import azure_upload # Imports the module responsible for uploading to Azure Data Lake Gen2

# Executes the main upload function
def main():

    azure_upload.upload_file_to_data_lake()

if __name__ == "__main__":
    main()