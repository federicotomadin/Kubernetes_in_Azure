# INSTALL

![image.png](/kubernetes_service.png)

# Login into az CLI

_g -> resource_group
n -> name_

```sh
az aks get-credentials -g <name_resource_group> -n <name_cluster> --overwrite-existing
```

# Create namespaces

ns -> namespace

```sh
kubectl create ns ingress-nginx
kubectl create ns cert-manager
```

# Install Ingress Controller


```sh
 kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/cloud/deploy.yaml 
```

# Show Ip generated and get the ID

```sh
az aks show --resource-group myResourceGroup --name myAKSCluster

az network public-ip show --resource-group MC_eflow-produccion_eflow-produccion_centralus  --ids ''

az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, 'xx.xxx.x.xxx')].[id]" --output tsv

az network public-ip update --ids ''  --dns-name hello-world-ingress

az network public-ip show --resource-group MC_eflow-produccion_eflow-produccion_centralus --id '' --query "{fqdn: dnsSettings.fqdn, address: ipAddress}"
```

# Install cluster-issuer

```sh
kubectl apply -f .\cluster-issuer.yaml -n ingress-basic
```

# Get Certificates

```sh
kubectl get pods -n cert-manager
```

# Install pods

```sh
kubectl apply -f .\aks-helloworld-one.yaml -n ingress-basic
kubectl apply -f .\aks-helloworld-two.yaml -n ingress-basic
```

# Install Ingress manifest

```sh
kubectl apply -f .\ingress-controller.yaml
```

# Install Jetstack to renew the issuer to certificates

```sh
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.yaml
```

# Install certificates

```sh
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
```

# Install CRDs

```sh
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.crds.yaml
```

# Get all certificates

```sh
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces
```

# Delete namespaces

```sh
kubectl delete namespace ingress-basic
kubectl delete namespace cert-manager
kubectl delete clusterissuer letsencrypt-staging
kubectl delete crd --all
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/vX.Y.Z/cert-manager.yaml
```

# Commands

```sh
kubectl -n ingress-basic get all

kubectl -n cert-manager get all

kubectl get svc -n cert-manager

kubectl get clusterissuer

kubectl get pods -n cert-manager

kubectl get certificates -n ingress-basic

kubectl describe certificate tls-secret

kubectl get nodes -o wide

kubectl get crd --all-namespaces
```

## INGRESS

```sh
kubectl get ingress -A

kubectl get pods -n ingress-nginx

```

## JOBS 

```sh
kubectl get jobs -n ingress-nginx

kubectl delete jobs --all -n ingress-nginx 
```

## CHECK INGRESS CLASS VERSION 

```sh
kubectl get ingressclass
```

## SECRETs

```sh
kubectl get sa

kubectl get secret xxxxxxxxx -o json

kubectl get secret -n ingress-nginx

kubectl get secret ingress-nginx-admission -n ingress-nginx
```

## CRDs

```sh
kubectl get crds | grep cert-manager
```

## CHALLENGE.ACME

```sh
kubectl get challenges.acme.cert-manager.io -A

az aks show -g eflow-prod  -n  eflow-prod

kubectl delete crd challenges.acme.cert-manager.io
```

## CERT MANAGER COMMANDS

```sh
kubectl get challenge <challenge-name> -ojsonpath='{.spec.authorizationURL}'

kubectl edit challenges.acme.cert-manager.io <pod_name>
```

## Get ingress-controller

```sh
kubectl --namespace ingress-basic get services -o wide -w ingress-nginx-controller
```

# Check URLs with cURL

_v -> verbose
k -> without restrictions_

```sh
curl -k https://hello-world-ingress.centralus.cloudapp.azure.com

curl -v https://hello-world-ingress.centralus.cloudapp.azure.com
```
