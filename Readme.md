# INSTALL

![image.png](/kubernetes_service.png)

# Login into az CLI

_-g -> resource_group
-n -> name_

```sh
az aks get-credentials -g <name_resource_group> -n <name_cluster> --overwrite-existing
```

# Create namespaces

ns -> namespace

```sh
kubectl create ns ingress-basic
kubectl create ns cert-manager
```

# Install certificates

## with Helm

```sh
helm install cert-manager jetstack/cert-manager `
--namespace cert-manager `
--set nodeSelector."kubernetes\.io/os"=linux `
--set installCRDs=false `
--set ingressShim.defaultIssuerName=letsencrypt-prod `
--set ingressShim.defaultIssuerKind=ClusterIssuer `
--set ingressShim.defaultIssuerGroup=cert-manager.io
```

## with Cert-manager

```sh
v1.3.0
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.0/cert-manager.yaml -n cert-manager

v1.2.0
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.2.0/cert-manager.crds.yaml -n cert-manager
```

# Get Certificates

```sh
kubectl get pods -n cert-manager
```

# Install cert-manager

```sh
helm repo add jetstack https://charts.jetstack.io

helm repo update

helm template cert-manager jetstack/cert-manager --namespace cert-manager | kubectl apply -f -
```

# Install Ingress Controller

## With Helm

```sh

 helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

 helm repo update

 helm install ingress-nginx ingress-nginx/ingress-nginx `
 --version 4.1.3 `
 --namespace ingress-basic `
 --set controller.replicaCount=1 `
 --set controller.nodeSelector."kubernetes\.io/os"=linux `
 --set controller.image.digest="" `
 --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux `
 --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz ` --set controller.admissionWebhooks.patch.image.digest="" `
 --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux `
 --set defaultBackend.image.digest=""
```

## With YAML

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.1/deploy/static/provider/cloud/deploy.yaml
```

# Show Ip generated and get the ID

```sh
az aks show --resource-group myResourceGroup --name myAKSCluster

az network public-ip show --resource-group MC_eflow-produccion_eflow-produccion_eastus  --ids ''

az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, xx.xxx.xxx.xxxs')].[id]" --output tsv

az network public-ip update --ids ''  --dns-name hello-world-ingress

az network public-ip show --resource-group MC_eflow-produccion_eflow-produccion_centralus --id '' --query "{fqdn: dnsSettings.fqdn, address: ipAddress}"
```

# Install pods

```sh
kubectl apply -f .\aks-helloworld-one.yaml -n ingress-basic
kubectl apply -f .\aks-helloworld-two.yaml -n ingress-basic
```

# Install Cluster Issuer

```sh
kubectl apply -f .\certificate.yaml -n cert-manager
kubectl apply -f .\cluster-issuer.yaml -n cert-manager
```

# Install Ingress manifest

```sh
kubectl apply -f .\hello-world-ingress.yaml -n ingress-basic
```

# Delete namespaces

```sh
kubectl delete namespace ingress-basic
kubectl delete namespace cert-manager
kubectl delete clusterissuer letsencrypt-prod
```

# Commands

```sh
kubectl -n ingress-basic get all

kubectl -n cert-manager get all

kubectl get svc -n cert-manager

kubectl get clusterissuer

kubectl get pods -n cert-manager

kubectl get certificates

kubectl describe certificate letsencrypt-prod

kubectl get nodes -o wide

```
