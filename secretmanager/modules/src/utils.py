from googleapiclient import discovery
from oauth2client.client import GoogleCredentials
from google.cloud import secretmanager

class ServiceAccountsClient:
    def __init__(self):
        credentials = GoogleCredentials.get_application_default()
        service = discovery.build("iam", "v1", credentials=credentials)
        self.client = service.projects().serviceAccounts()

    def create_key(self, service_account_name):
        key = self.client.keys().create(name=service_account_name).execute()
        return key["privateKeyData"]

    def delete_key(self, service_account_name):
        resp = (
            self.client.keys()
            .list(name=service_account_name, keyTypes=["USER_MANAGED"])
            .execute()
        )
        keys = resp.get("keys", [])
        for k in keys:
                self.client.keys().delete(name=k["name"]).execute()

def add_secret_version(project_id, secret_id, payload):
    # Create the Secret Manager client.
    client = secretmanager.SecretManagerServiceClient()

    # Build the resource name of the parent secret.
    parent = client.secret_path(project_id, secret_id)

    # Add the secret version.
    response = client.add_secret_version(
        request={
            "parent": parent,
            "payload": {"data": payload},
        }
    )

    return response.name