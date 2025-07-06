#!/bin/bash

# Initialize Terraform (if not already done)

# Run terraform plan with detailed exit code
# We redirect stderr to stdout (2>&1) and then discard all output to /dev/null
# initially, so we only print it if there are changes.
sh export_subscription.sh plan -detailed-exitcode -out=tfplan.out > /dev/null 2>&1
PLAN_EXIT_CODE=$?
echo $PLAN_EXIT_CODE
if [ "$PLAN_EXIT_CODE" -eq "2" ]; then
    echo "There is some changes."
elif [ "$PLAN_EXIT_CODE" -eq "1" ]; then
    echo "Error occured."
elif [ "$PLAN_EXIT_CODE" -eq "0" ]; then
    echo "No changes needed."
else
    echo "Unknow error occured."
fi
