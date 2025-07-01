az login --service-principal \
    -u "$AZURE_CLIENT_ID" \
    -p "$AZURE_CLIENT_SECRET" \
    --tenant "$AZURE_TENANT_ID" \
    --output none # Suppress login output for security

echo "Successfully logged into Azure CLI."

# Set the default subscription (important if your SP has access to multiple)
az account set --subscription "$AZURE_SUBSCRIPTION_ID"
echo "Default Azure subscription set."