#!/bin/sh
export TF_VAR_az_subscription_id=$(az account show --query id --output tsv)
# Add an echo to confirm it's working inside the script
terraform $1
cp ../ansible/vars.yml /var/lib/jenkins/vars.yml

