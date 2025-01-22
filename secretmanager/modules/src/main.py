import base64
import json
import logging
import os
import re

from utils import ServiceAccountsClient
from utils import add_secret_version
from utils import delete_old_secret_versions

project = os.environ.get('PROJECT')

def process_pubsub_event(event, context):
    message = base64.b64decode(event['data']).decode('utf-8')
    msg = json.loads(message)
    secret_name = msg.get('name')

    if "rotation" in msg:
        if '-json-key' in secret_name:
            # Get service account name from secret name
            sn = secret_name.rsplit('/', 1)[-1]
            service_account_name = sn[:-9]  # Strip "-json-key" suffix
            service_account_client = ServiceAccountsClient()

            # Determine the service account email domain
            if service_account_name == project:
                # If the service_account_name is equal to the project value
                domain = "appspot.gserviceaccount.com"
            elif re.match(r"^\d{13}-$", service_account_name):
                # If the service_account_name is 13 digits followed by a hyphen
                domain = "developer.gserviceaccount.com"
            else:
                # Default to the standard domain
                domain = f"{project}.iam.gserviceaccount.com"

            # Construct the service account email
            service_account = f"{service_account_name}@{domain}"
            sa_name = f"projects/{project}/serviceAccounts/{service_account}"

            # Delete the old JSON key
            service_account_client.delete_key(sa_name)

            # Add a new JSON key
            private_key = service_account_client.create_key(sa_name)

            # Delete old secret versions
            delete_old_secret_versions(project, sn)

            # Add a new secret version
            add_secret_version(project, sn, private_key)

            rotation_time = msg['rotation']['nextRotationTime']
            print(f"Rotated Secret: {sn}, Next Rotation Time: {rotation_time}")