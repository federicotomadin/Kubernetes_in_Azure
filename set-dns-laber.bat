# Public IP address of your ingress controller
$IP="xx.xxx.xxx.xxx"

# Name to associate with public IP address
$DNSNAME="hello-world-ingress"

# Get the resource-id of the public ip
PUBLICIPID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]" --output tsv)

# Update public ip address with DNS name
az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME

# Display the FQDN
az network public-ip show --ids /subscriptions/cb36e899-b6f8-43dc-badb-d4c425aafcb4/resourceGroups/mc_eflow-produccion_eflow-produccion_centralus/providers/Microsoft.Network/publicIPAddresses/kubernetes-a3a2d8462a2c346189ab3165309530f4 --query "[dnsSettings.fqdn]" --output tsv


az network public-ip update --ids /subscriptions/cb36e899-b6f8-43dc-badb-d4c425aafcb4/resourceGroups/mc_eflow-produccion_eflow-produccion_centralus/providers/Microsoft.Network/publicIPAddresses/kubernetes-a3a2d8462a2c346189ab3165309530f4  --dns-name hello-world-ingress