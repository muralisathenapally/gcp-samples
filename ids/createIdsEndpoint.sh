#!/bin/bash

ENDPOINT_NAME=$1
VPC_NETWORK=$2
REGION=$3
ZONE=$4
SEVERITY=$5
PROJECT_ID=$6
POLICY_NAME="$ENDPOINT_NAME-policy"
DATASET_NAME="ids_logs"
SINK_NAME="$PROJECT_ID-ids-logs-bq"

#Exit if no arguments are given
if [ $# -eq 0 ]
  then
    echo "                  No arguments supplied, below arguments are needed in the same order"
    echo "                  ENDPOINT_NAME VPC_NETWORK REGION ZONE SEVERITY PROJECT_ID"
    exit 1
fi

#Create endpoint
echo "... Creating IDS Endpoint: $ENDPOINT_NAME ..."
gcloud ids endpoints create $ENDPOINT_NAME  --network=$VPC_NETWORK --zone=$ZONE  --severity=$SEVERITY --project=$PROJECT_ID --no-async
if [ $? -eq 0 ]; then
   echo "... IDS Endpoint: $ENDPOINT_NAME Created Successfully..."
else
   echo "Failed to create IDS Endpoint"
   exit 1
fi

#Get endpointForwardingRule
ENDPOINT_FORWARDING_RULE=$(gcloud ids endpoints describe $ENDPOINT_NAME --zone $ZONE --project $PROJECT_ID | grep "endpointForwardingRule" | awk '{ print $2 }')

#Get subnets from the network
SUBNETS=$(gcloud compute networks subnets list --network=$VPC_NETWORK --filter="region:( $REGION )" | grep NAME | awk '{print $2}' ORS=',')

#Create packet mirroring policy
echo "... Creating Packet Mirroring Policy: $POLICY_NAME ..."
gcloud compute packet-mirrorings create $POLICY_NAME --project=$PROJECT_ID --region=$REGION --collector-ilb=$ENDPOINT_FORWARDING_RULE --network=$VPC_NETWORK --mirrored-subnets=$SUBNETS
if [ $? -eq 0 ]; then
   echo "... Packet Mirroring Policy: $POLICY_NAME Created Successfully..."
else
   echo "Failed to create Packet Mirroring Policy"
   exit 1
fi

#Create bigquery dataset
bq --location=US mk -d --description "IDS Logs Dataset" $DATASET_NAME

if [ $? -eq 0 ]; then
    #Create Logging sink to export ids logs to bigquery
    echo "Setting up logs export to biquery"
    gcloud alpha logging sinks create $SINK_NAME bigquery.googleapis.com/projects/$PROJECT_ID/datasets/$DATASET_NAME --log-filter="logName=\"projects/$PROJECT_ID/logs/ids.googleapis.com%2Fthreat\""
    SINK_SA=$(gcloud logging sinks describe $SINK_NAME | grep writerIdentity | awk '{print $2}')
    gcloud projects add-iam-policy-binding $PROJECT_ID --member=$SINK_SA --role=roles/bigquery.dataEditor > /dev/null
    echo "IDS Threat logs will be available in dataset: $DATASET_NAME "
else
   echo "Failed to create bq dataset"
   exit 1
fi

