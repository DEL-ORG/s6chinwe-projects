#!/bin/bash

# Set PostgreSQL database credentials
DB_HOST="$DB_HOST"
DB_PORT="$DB_PORT"
DB_NAME="$DB_NAME"
DB_USER="$DB_USER"

BACKUP_DIR="/backup"


# Create a timestamp for the backup file
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="$DB_NAME-$TIMESTAMP.sql"

# Create a backup of the PostgreSQL database
PGPASSWORD=$DB_PASSWORD pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -Fc > $BACKUP_DIR/$BACKUP_FILE


# Copy the backup file to the S3 bucket
aws s3 cp $BACKUP_DIR/$BACKUP_FILE s3://$S3_BUCKET

# Clean up the local backup file
rm $BACKUP_DIR/$BACKUP_FILE
