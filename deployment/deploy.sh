#!/bin/bash
set -e

# Randomized bucket and key names
STACK_NAME="grad-project-stack-9876"
REGION="us-east-1"
LAMBDA_BUCKET="grad-project-lambda-bucket-1234"
LAMBDA_KEY="image_processor_random.zip"
TEMPLATE_FILE="../templates/main.yaml"

echo "Packaging Lambda function..."
cd ../src/image_processor
zip -r ../../image_processor.zip .
cd ../../deployment

echo "Uploading Lambda package to S3..."
aws s3 cp ../image_processor.zip s3://$LAMBDA_BUCKET/$LAMBDA_KEY --region $REGION

echo "Deploying CloudFormation stack..."
aws cloudformation deploy \
    --stack-name $STACK_NAME \
    --template-file $TEMPLATE_FILE \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides LambdaS3CodeBucket=$LAMBDA_BUCKET LambdaS3CodeKey=$LAMBDA_KEY \
    --region $REGION

echo "Deployment complete!"
