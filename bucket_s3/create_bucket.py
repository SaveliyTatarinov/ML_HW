from dotenv import load_dotenv
import os
import boto3
from botocore.exceptions import ClientError, NoCredentialsError

load_dotenv()

def create_bucket(bucket_name):
    s3 = boto3.client(
        "s3",
        endpoint_url="http://localhost:9000",
        aws_access_key_id=os.getenv("MINIO_ROOT_USER"),
        aws_secret_access_key=os.getenv("MINIO_ROOT_PASSWORD"),
    )
    try:
        response = s3.head_bucket(Bucket=bucket_name)
        print(f"Bucket '{bucket_name}' already exists.")
        return

    except ClientError as e:
        if e.response['Error']['Code'] == '404':
            try:
                s3.create_bucket(Bucket=bucket_name)
                print(f"Bucket '{bucket_name}' created successfully.")
            except ClientError as e:
                print(f"Error creating bucket '{bucket_name}': {e}")
            except NoCredentialsError as e:
                print(f"No MinIO credentials found. Please set MINIO_ROOT_USER and MINIO_ROOT_PASSWORD environment variables.")

        else:
            print(f"Error checking bucket '{bucket_name}': {e}")

if __name__ == "__main__":
    bucket_name = "data-bucket"
    create_bucket(bucket_name)