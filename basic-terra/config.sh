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
if aws s3api head-bucket --bucket "$S3_BUCKET_NAME" &>/dev/null; then
    echo "S3 bucket $S3_BUCKET_NAME already exists. Skipping bucket creation."
else
    echo "Creating S3 bucket: $S3_BUCKET_NAME in region: $AWS_REGION"
    aws s3api create-bucket --bucket "$S3_BUCKET_NAME" --region "$AWS_REGION" --create-bucket-configuration LocationConstraint="$AWS_REGION"

    echo "Enabling versioning on S3 bucket: $S3_BUCKET_NAME"
    aws s3api put-bucket-versioning --bucket "$S3_BUCKET_NAME" --versioning-configuration Status=Enabled
    echo "S3 bucket created and versioning enabled!"
fi

#Create DynamoDB table for state locking
if aws dynamodb describe-table --table-name "$DYNAMODB_TABLE_NAME" --region "$AWS_REGION" >/dev/null 2>&1; then
    echo "DynamoDB table $DYNAMODB_TABLE_NAME already exists. Skipping table creation."
else

    echo "Creating DynamoDB table: $DYNAMODB_TABLE_NAME for Terraform state locking"
    aws dynamodb create-table \
        --table-name "$DYNAMODB_TABLE_NAME" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
        --region "$AWS_REGION" >/dev/null

    echo "DynamoDB table created for state locking!"
fi