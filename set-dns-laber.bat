# Public IP address of your ingress controller
$IP="xx.xxx.xxx.xxx"

# Name to associate with public IP address
$DNSNAME="hello-world-ingress"

# Get the resource-id of the public ip
PUBLICIPID=$(az network public-ip list --query "[?ipAddress!=null]&[?resource_group=='eflow-produccion']" --output tsv)

# Update public ip address with DNS name
az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME

# Display the FQDN
az network public-ip show --id '' --query "[dnsSettings.fqdn]" --output tsv
