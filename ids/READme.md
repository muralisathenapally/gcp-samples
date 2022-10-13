Script will create: <br />

Ids endpoint <br />
Packet mirroring policy <br />
Dataset for storing logs <br />
Logging sink to export logs to bigquery dataset <br />


Usage:<br />
Run below command by substituting the appropriate values in the same order

**bash createIdsEndpoint.sh ENDPOINT_NAME VPC_NAME SUBNET_REGION ZONE SEVERITY PROJECT_ID**

ENDPOINT_NAME - Name of the IDS endpont <br />
VPC_NAME      - Name of the VPC <br />
REGION        - Region of subnet <br />
ZONE          - Any Zone in above region <br />
SEVERITY      - Can be one of below <br />

                    INFORMATIONAL
                    LOW
                    MEDIUM
                    HIGH
                    CRITICAL

PROJECT_ID    - Project Id

