from flask import Flask, request, jsonify
import json
import base64
import uuid
import requests
from string import Template
import os
from google.cloud import bigquery
import subprocess

app = Flask(__name__)

ack_url = os.environ.get('ACK_SERVICE_URL')
project = os.environ.get('PROJECT')
dataset = os.environ.get('DATASET')
table = os.environ.get('TABLE')

@app.route("/", methods=["POST"])
def index():
    """Receive and parse Pub/Sub messages."""
    envelope = request.get_json()
    # Check if the Pub/Sub message is present
    if not envelope:
        msg = "No Pub/Sub message received"
        print(f"error: {msg}")
        return f"Bad Request: {msg}", 400

    if not isinstance(envelope, dict) or "message" not in envelope:
        msg = "Invalid Pub/Sub message format"
        print(f"error: {msg}")
        return f"Bad Request: {msg}", 400

    pubsub_message = envelope["message"]
    
    # Check if "data" exists in the message and decode it safely
    if isinstance(pubsub_message, dict) and "data" in pubsub_message:
        try:
            original_asset_data = base64.b64decode(pubsub_message["data"]).decode("utf-8").strip()
            original_asset_data_encoded = pubsub_message["data"]
        except Exception as e:
            print(f"Error decoding message: {e}")
            return f"Bad Request: Error decoding message", 400

        print(f"Received data: {original_asset_data}")
    else:
        msg = "No data field in Pub/Sub message"
        print(f"error: {msg}")
        return f"Bad Request: {msg}", 400

    # Proceed with JSON decoding for the asset data
    try:
        asset_json = json.loads(original_asset_data)

    except json.JSONDecodeError as e:
        print(f"JSONDecodeError: {e}")
        return f"Bad Request: Invalid JSON data", 400

    # Processing the asset data
    guidstr = str(uuid.uuid4())
    created_ts = asset_json.get("window", {}).get("startTime", "unknown")
    ackurl = ack_url + "/ack?uuid={id_to_ack}".format(id_to_ack=guidstr)

    asset_type = asset_json.get("asset", {}).get("assetType", "unknown")
    asset_name = asset_json.get("asset", {}).get("name", "unknown")
    event_type = "CAI-triggered event"
    if 'deleted' not in asset_json:
        event_type = "CREATE or UPDATE event"
    else:
        event_type = "DELETE event"

    print("UUID:", guidstr)
    print("Type-of-change:", event_type)
    print("Created timestamp:", created_ts)

    print('printing asset info')

    print(asset_type)
    print(asset_name)
    
    # Construct and send data to Teams
    notificationtype = asset_type.split('.')[0]
    whurl = 'https://dummy.webhook.office.com'

    data_template = Template('{"text": "UGCS RESOURCE UPDATE ALERT - A $eventType happened on $assetType identified by $assetName. \n\n Acknowledge by clicking this URL: $acknowledgeURL"}')
    data = data_template.substitute(eventType=event_type, assetType=asset_type, assetName=asset_name, acknowledgeURL=ackurl)

    response = requests.post(whurl, data=data)
    if response.status_code == 200:
        print('Successfully sent data to Teams')
    else:
        print('Error sending data to Teams:', response.status_code)
    
    # Insert into BigQuery
    insert_client = bigquery.Client()
    insert_stmt = f"INSERT `{project}.{dataset}.{table}` (data, uuid, creationtimestamp, notifiedtimestamp, notificationtype) VALUES('{original_asset_data_encoded}', '{guidstr}', '{created_ts}', CURRENT_TIMESTAMP(), '{notificationtype.upper()}');"
    insert_job = insert_client.query(insert_stmt)
    insert_job.result()
    print("Successfully persisted message with UUID:", guidstr)

    return "", 204