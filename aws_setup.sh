aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" &&
aws configure set aws_secret_access_key "$AWS_ACCESS_KEY_SECRET" &&
aws configure set region "$AWS_REGION" --profile user2 && 
aws configure set output "json" 
