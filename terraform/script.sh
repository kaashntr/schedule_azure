#!/bin/bash

# Initialize Terraform (if not already done)

# Run terraform plan with detailed exit code
# We redirect stderr to stdout (2>&1) and then discard all output to /dev/null
# initially, so we only print it if there are changes.
terraform plan -detailed-exitcode -out=tfplan.out > /dev/null 2>&1
PLAN_EXIT_CODE=$?
echo $PLAN_EXIT_CODE

