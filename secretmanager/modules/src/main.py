import base64
import json
import google.cloud.logging
import logging

def process_pubsub_event(event, context):
  message = base64.b64decode(event['data']).decode('utf-8')

  msg = json.loads(message)

  secret_name = msg.get('name')
  roation_time = msg['rotation']['nextRotationTime']
  
  logging_client = google.cloud.logging.Client()
  cloud_logger = logging_client.logger('secret-rotation-log')
  
  log_entry = ("Rotate Secret: " + secret_name + ", Next Roation Time: " + roation_time)
  cloud_logger.log(log_entry, severity='INFO')