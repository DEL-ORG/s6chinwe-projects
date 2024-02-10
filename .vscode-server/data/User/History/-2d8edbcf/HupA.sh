#!/bin/bash

# Set PostgreSQL database credentials
HOST="$DB_HOST"
PORT="$DB_PORT"
DATABASE="$DB_NAME"
USER="$DB_USER"

BACKUP_DIR="/backup"

## Set S3 bucket name and AWS credentials
#S3_BUCKET="del-db-backup/S6/s6chinwe/"
#AWS_ACCESS_KEY_ID="AKIAZI2LE2Z6CLDSGQZ7"
#AWS_SECRET_ACCESS_KEY="j4lfVWjpnLvWMLdJQ4YiQZ35EGMnoMxQE/XGW6dIyour_aws_secret_access_key"

# Create a timestamp for the backup file
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="$PGDATABASE-$TIMESTAMP.sql"

# Create a backup of the PostgreSQL database
PGPASSWORD=$DB_PASSWORD pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -Fc > $BACKUP_DIR/$BACKUP_FILE
#
# Copy the backup file to the S3 bucket
#aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
#aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
#aws configure set default.region "us-east-1"

# Copy the backup file to the S3 bucket
aws s3 cp $BACKUP_DIR/$BACKUP_FILE s3://$S3_BUCKET/ --access-key=$AWS_ACCESS_KEY_ID --secret-key=$AWS_SECRET_ACCESS_KEY

# Clean up the local backup file
rm $BACKUP_DIR/$BACKUP_FILE