#!/bin/bash

#Environment variables
S3_BUCKET_NAME="my-terraform-state-bucket-andreghs-2026"
DYNAMODB_TABLE_NAME="terraform-state-lock"
STATE_KEY="terraform.tfstate"


#Empty bucket

echo "Emptying S3 bucket: $S3_BUCKET_NAME..."
if aws s3api head-bucket --bucket "$S3_BUCKET_NAME" >/dev/null 2>&1; then
    echo "Checking if bucket is versioned..."
    if aws s3api get-bucket-versioning --bucket "$S3_BUCKET_NAME"; then 
        echo "Bucket is versioned. Deleting all versions and delete markers..."
        objects_to_delete=$(aws s3api list-object-versions \
                --bucket "$S3_BUCKET_NAME" \
                --output=json \
                --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}' \
                --region "$AWS_REGION")

        if  [ "$(echo "$objects_to_delete" | jq '.Objects | length')" -gt 0 ] || \
            [ "$(echo "$objects_to_delete" | jq '.DeleteMarkers | length')" -gt 0 ]; then
            echo "Bucket has object versions or delete markers."
            aws s3api delete-objects --bucket "$S3_BUCKET_NAME" --delete "$objects_to_delete" --region "$AWS_REGION"
            echo "S3 bucket emptied"
        else
            echo "No object versions found."
        fi
        
    else 
        echo "Bucket is not versioned. Deleting all objects..."
        aws s3 rm s3://"$S3_BUCKET_NAME" --region "$AWS_REGION" --recursive #if not versioned
    fi

    echo "S3 bucket emptied. Deleting bucket..."
    aws s3 rb s3://"$S3_BUCKET_NAME" --region "$AWS_REGION"

else
    echo "S3 bucket $S3_BUCKET_NAME does not exist. Skipping bucket deletion."
fi




#Delete DynamoDB table
if aws dynamodb describe-table --table-name "$DYNAMODB_TABLE_NAME" --region "$AWS_REGION" >/dev/null 2>&1; then
    echo "DynamoDB table $DYNAMODB_TABLE_NAME exists. Deleting table..."
    aws dynamodb delete-table --table-name "$DYNAMODB_TABLE_NAME" --region "$AWS_REGION"
    echo "DynamoDB table deleted!"
else
    echo "DynamoDB table $DYNAMODB_TABLE_NAME does not exist. Skipping table deletion."
fi


echo "All resources deleted successfully!"