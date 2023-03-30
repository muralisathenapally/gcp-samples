OUTPUT_FILE="service_accounts_list"
echo "" > $OUTPUT_FILE
for list in `gcloud projects list | grep "PROJECT_ID" | awk '{print $2}'`
do
echo  >> $OUTPUT_FILE
echo "Servie Accounts from Project : $list" >> $OUTPUT_FILE
echo "====================================================="  >> $OUTPUT_FILE
gcloud asset search-all-iam-policies --scope=projects/$list --query="memberTypes:serviceAccount" --flatten="policy.bindings[].members" --format="table(policy.bindings.members,policy.bindings.role)" >> $OUTPUT_FILE
done