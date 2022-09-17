$StorageAccount = "salesstoraccalexei"
$StorageContainer = "stagingcontainer"
$DirectoryName = "/stagingdirectory"

# CAUTION : in order to make the storage account a gen2, you need to set *hierarchical-namespace* as true.

az storage account create `
    --name $StorageAccount `
    --resource-group $RGName `
    --location $RGLocation `
    --sku Standard_LRS `
    --kind StorageV2 `
    --hierarchical-namespace true


az storage container create `
    --resource-group $RGName `
    --name $StorageContainer `
    --account-name $StorageAccount


az storage fs directory create `
    --name $DirectoryName `
    --file-system $StorageContainer `
    --account-name $StorageAccount `
    --auth-mode key 




    
