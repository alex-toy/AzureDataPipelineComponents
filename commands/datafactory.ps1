#######################################################################
"datafactory :"

$Global:Factory = "salesfactoryalexei"

az datafactory create `
    --location $RGLocation `
    --name $Factory `
    --resource-group $RGName