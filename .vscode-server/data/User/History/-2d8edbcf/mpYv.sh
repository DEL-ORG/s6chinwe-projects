#!/bin/bash

S3_BUCKET="del-db-backup/S6/s6chinwe"

# Set the database credentials and S3 bucket information
DB_USER="$DB_USER"
DB_NAME="$DB_NAME"
DB_HOST="$DB_HOST"
DB_PORT="$DB_PORT"

BACKUP_DIR="/backup"

# Set the timestamp for the backup file
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$DB_NAME-$TIMESTAMP.sql"

# Perform the database backup
PGPASSWORD=$DB_PASSWORD pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME > $BACKUP_DIR/$BACKUP_FILE

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Database backup successful."

   # Upload the backup file to S3
aws s3 cp $BACKUP_DIR/$BACKUP_FILE s3://$S3_BUCKET

# Capture the exit status of aws s3 cp command
AWS_CP_STATUS=$?

# Check if upload to S3 was successful
if [ $AWS_CP_STATUS -eq 0 ]; then
    echo "Backup uploaded to S3 successfully."
    
    # Clean up the local backup file
    rm "$BACKUP_DIR/$BACKUP_FILE"
    
    exit 0
else
    echo "Error: Failed to upload backup to S3."
    exit 1
fi