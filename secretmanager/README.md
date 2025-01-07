This code will deploy following resources

* secret(s) with specified rotation details
* pubsub topic
* cloud function

## How it works ##
when a secret with rotation perioid ex:30 days is specified, secret manager will send a rotation notification to pubsub when 30 is over.
pubsub will then send that message to cloudfunction.

cloudfunction is programmed to identify the service account name for that rotation is needed and then delete the current key that service account and generate a new one.
once the new key is generated, it will be stored in the secret manager secret corresponding to that service account.

## Usage ##
Application/users that utilise the key of a service account which has roation enabled, will have to get new key and use it based on the roation perioid otherwise they face authentication errors.
for ex: if a service account has rotation period is set to 30 days, Application/users should get the service account key from secret manager once the rotation period of 30 days is over. otherwise their access to gcp is lost 
