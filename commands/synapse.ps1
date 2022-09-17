$Global:SynapseWorkSpace = "sales-ws"
$Global:StorageAccountGen2 = "salesgen2"
$Global:FileSystemGen2 = "salessynapsefs"
$Global:SQLPool = "salessqlpool"

az storage fs create `
    -n $FileSystemGen2 `
    --account-name $StorageAccountGen2 `
    --auth-mode login

az synapse workspace create `
    --name $SynapseWorkSpace `
    --resource-group $RGName `
    --storage-account $StorageAccountGen2 `
    --file-system $FileSystemGen2 `
    --sql-admin-login-user sqladminuser `
    --sql-admin-login-password Password123! `
    --location $RGLocation


az synapse sql pool create `
    --name $SQLPool `
    --resource-group $RGName `
    --performance-level "DW100c" `
    --workspace-name $SynapseWorkSpace `
    # [--collation]
    # [--no-wait]
    # [--storage-type {GRS, LRS}]
    # [--tags]