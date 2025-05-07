from src import azure_upload # Imports the module responsible for uploading to Azure Blob Storage

# Executes the main upload function
def main():

    azure_upload.upload_file_to_blob()

if __name__ == "__main__":
    main()