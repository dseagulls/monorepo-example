import os
import subprocess
from azure.mgmt.resource import SubscriptionClient
from azure.common.credentials import ServicePrincipalCredentials

# Retrieve the IDs and secret to use with ServicePrincipalCredentials
subscription_id = os.environ["subscription_id"]
tenant_id = os.environ["tenant_id"]
client_id = os.environ["client_id"]
client_secret = os.environ["client_secret"]

credential = ServicePrincipalCredentials(tenant=tenant_id, client_id=client_id, secret=client_secret)

subscription_client = SubscriptionClient(credential)

subscription = next(subscription_client.subscriptions.list())
print(subscription.subscription_id)

process = subprocess.Popen(['helm', 'version'], 
                           stdout=subprocess.PIPE,
                           universal_newlines=True)

output = process.stdout.readline()
print(output.strip())
