#!/bin/bash
set -e

#Environment variables
S3_BUCKET_NAME="my-terraform-state-bucket-andreghs-2026"
DYNAMODB_TABLE_NAME="terraform-state-lock"
STATE_KEY="terraform.tfstate"

# Verify AWS credentials are configured
if ! aws sts get-caller-identity &>/dev/null; then
    echo "ERROR: AWS credentials not configured. Run 'aws configure' first."
    exit 1
fi

#Create S3 bucket
echo "Creating S3 bucket: $S3_BUCKET_NAME in region: $AWS_REGION"
aws s3api create-bucket --bucket "$S3_BUCKET_NAME" --region "$AWS_REGION" --create-bucket-configuration LocationConstraint="$AWS_REGION"

echo "Enabling versioning on S3 bucket: $S3_BUCKET_NAME"
aws s3api put-bucket-versioning --bucket "$S3_BUCKET_NAME" --versioning-configuration Status=Enabled

echo "S3 bucket created and versioning enabled!"

#Create DynamoDB table for state locking