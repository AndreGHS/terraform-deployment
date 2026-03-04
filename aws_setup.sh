#!/bin/bash
set -e

echo "========================================"
echo "AWS Credentials Configuration"
echo "========================================"

# Debug: show what variables are available
echo "DEBUG: AWS_ACCESS_KEY_ID = ${AWS_ACCESS_KEY_ID:-'NOT SET'}"
echo "DEBUG: AWS_SECRET_ACCESS_KEY = ${AWS_SECRET_ACCESS_KEY:-'NOT SET'}"
echo "DEBUG: AWS_REGION = ${AWS_REGION:-'NOT SET'}"
echo ""

# Check if environment variables are provided, otherwise use interactive mode
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_REGION" ]; then
    echo "Using interactive mode (enter your credentials):"
    aws configure
else
    echo "Configuring from environment variables..."
    aws configure set aws_access_key_id "FIX"
    aws configure set aws_secret_access_key "FIX"
    aws configure set region "eu-north-1"
    aws configure set output "json"
    echo "✓ Configuration complete"
fi

# Verify credentials are working
echo ""
echo "Verifying AWS credentials..."
if aws sts get-caller-identity &>/dev/null; then
    echo "✓ AWS credentials configured successfully!"
    aws sts get-caller-identity --output table
else
    echo "✗ ERROR: AWS credentials not working. Please check your credentials."
    exit 1
fi