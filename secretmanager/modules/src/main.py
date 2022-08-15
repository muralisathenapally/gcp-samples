import base64

def process_pubsub_event(event, context):
  message = base64.b64decode(event['data']).decode('utf-8')

  msg = json.loads(message)

  secret_name = msg.get('name')
  roation_time = msg['rotation']['nextRotationTime']

  print("Rotate Secret:" + secret_name + " Next Roation Time:" + roation_time)
