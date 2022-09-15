import base64
import json
import google.cloud.logging
import logging
import os

from utils import ServiceAccountsClient
from utils import add_secret_version
from utils import delete_old_secret_versions

project = os.environ.get('PROJECT')

def process_pubsub_event(event, context):
  message = base64.b64decode(event['data']).decode('utf-8')
  msg = json.loads(message)
  secret_name = msg.get('name')

  if '-json-key' in secret_name:
      #get sa name
      sn = secret_name.rsplit('/', 1)[-1]
      service_account_name = str(sn[:-9])
      service_account_client = ServiceAccountsClient()

      #construct sa email
      service_account = f"{service_account_name}@{project}.iam.gserviceaccount.com"
      sa_name = f"projects/{project}/serviceAccounts/{service_account}"

      #delete delete old json key
      service_account_client.delete_key(sa_name)

      #add new json key
      private_key = service_account_client.create_key(sa_name)

      #delete old secret version
      delete_old_secret_versions(project, sn)

      #add secret version
      add_secret_version(project, sn, private_key)

  else:
      roation_time = msg['rotation']['nextRotationTime']
      logging_client = google.cloud.logging.Client()
      cloud_logger = logging_client.logger('secret-rotation-log')

      log_entry = ("Rotate Secret: " + secret_name + ", Next Roation Time: " + roation_time)
      cloud_logger.log(log_entry, severity='INFO')