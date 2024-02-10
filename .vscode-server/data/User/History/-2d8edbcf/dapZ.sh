#!/bin/bash

# Set PostgreSQL database credentials
HOST="$DB_HOST"
PORT="$DB_PORT"
DATABASE="$DB_NAME"
USER="$DB_USER"

BACKUP_DIR="/backup"

# Set S3 bucket name and AWS credentials
#3_BUCKET="your_s3_bucket_name"
#AWS_ACCESS_KEY_ID="your_aws_access_key_id"
#AWS_SECRET_ACCESS_KEY="your_aws_secret_access_key"

# Create a timestamp for the backup file
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="$PGDATABASE-$TIMESTAMP.sql"

# Create a backup of the PostgreSQL database
PGPASSWORD=$DB_PASSWORD pg_dump -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -Fc > $BACKUP_DIR/$BACKUP_FILE

# Copy the backup file to the S3 bucket
aws s3 cp $BACKUP_DIR/$BACKUP_FILE s3://$S3_BUCKET/ --access-key=$AWS_ACCESS_KEY_ID --secret-key=$AWS_SECRET_ACCESS_KEY

# Clean up the local backup file
rm $BACKUP_DIR/$BACKUP_FILE