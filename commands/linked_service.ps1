
az datafactory linked-service create `
    --factory-name $Factory `
    --resource-group $RGName `
    --name "AzureSqlDatabase1" `
    --properties "{\"type\":\"AzureStorage\",\"typeProperties\":{\"connectionString\":{\"type\":\"SecureString\",\"value\":\"DefaultEndpointsProtocol=https;AccountName=nycpayrollsaalexei2;AccountKey=<storage key>\"}}}" 




# az datafactory linked-service create `
#     --factory-name $Factory `
#     --resource-group $RGName `
#     --name "AzureDataLakeStorage1" `
#     --properties "{\"type\":\"AzureStorage\",\"typeProperties\":{\"connectionString\":{\"type\":\"SecureString\",\"value\":\"DefaultEndpointsProtocol=https;AccountName=nycpayrollsaalexei2;AccountKey=<storage key>\"}}}" 