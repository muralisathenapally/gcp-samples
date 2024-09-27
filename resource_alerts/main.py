#!/usr/bin/python3
import datetime
from datetime import date
import uuid
import json
import base64
import string
import re
import requests
import os

date = datetime.datetime.now()
print("Time now is ", date)

from flask import Flask, request
#from pydantic import BaseModel
from google.cloud import bigquery
from google.cloud import resourcemanager_v3
import json
from google.cloud import storage
from ast import literal_eval

app = Flask(__name__)

today_folder = date.strftime('%Y-%m-%d')
print("Folder:", today_folder)

project = os.environ.get('PROJECT')
dataset = os.environ.get('DATASET')
table = os.environ.get('TABLE')

@app.route("/", methods=["GET"])
def root():
    """Default route that provides a message with the environment variables."""
    print("You cannot invoke this service without the right parameters - ", project, '.', dataset, '.', table)
    return {
        "message": "You cannot invoke this service without the right parameters",
        "project": project,
        "dataset": dataset,
        "table": table
    }, 400


@app.route("/ack", methods=["GET"])
def ack():
    """Route to acknowledge a UUID."""
    uuid_value = request.args.get("uuid")
    if not uuid_value:
        return {"error": "UUID is required"}, 400

    # Direct query
    client = bigquery.Client()
    update = f"UPDATE `{project}.{dataset}.{table}` SET acktimestamp = CURRENT_TIMESTAMP() WHERE uuid='{uuid_value}';"
    print("UPDATE query:", update)

    # Execute the update query
    update_job = client.query(update)
    update_results = update_job.result()
    print("Result of update query:", update_results)

    return {"Successfully updated your response for uuid": uuid_value}, 200


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get("PORT", 8080)))