import json
import time
import boto3
from uuid import uuid4

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ContactFormSubmissionsTable')


def lambda_handler(event, context):
    try:
        # Parse form data from request body
        data = json.loads(event['body'])

        # Create database item
        response = table.put_item(
            Item={
                'email': data['email'],
                'timestamp': str(time.time()),  # Epoch timestamp
                'submission_id': str(uuid4()),  # Unique ID
                'firstName': data['firstName'],
                'lastName': data['lastName'],
                'message': data['message']
            }
        )

        # Return success response
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'OPTIONS,POST'
            },
            'body': json.dumps({'message': 'Submission saved successfully!'})
        }

    except Exception as e:
        # Return error response
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }