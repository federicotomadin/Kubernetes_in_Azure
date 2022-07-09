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
kubectl create ns ingress-basic
kubectl create ns cert-manager
```

# Install Ingress Controller

## With Helm

```sh

 helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

 helm repo update

 helm install ingress-nginx ingress-nginx/ingress-nginx `
 --namespace ingress-basic `
 --set controller.replicaCount=1 `
 --set controller.nodeSelector."kubernetes\.io/os"=linux `
 --set controller.image.digest="" `
 --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux `
 --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz ` --set controller.admissionWebhooks.patch.image.digest="" `
 --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux `
 --set defaultBackend.image.digest=""
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
kubectl apply -f .\ingress-controller-without-tls.yaml -n ingress-basic
```

# Install certificates

## with Helm

```sh
helm install `
    cert-manager jetstack/cert-manager `
    --namespace cert-manager `
    --version v1.5.3 `
    --create-namespace `
    --set installCRDs=true
```

# Install Cluster Issuer withour TLS

```sh
kubectl apply -f .\cluster-issuer.yaml
```

# Delete namespaces

```sh
kubectl delete namespace ingress-basic
kubectl delete namespace cert-manager
kubectl delete clusterissuer letsencrypt-staging
kubectl delete crd --all
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

## Get ingress-controller

```sh
kubectl --namespace ingress-basic get services -o wide -w ingress-nginx-controller
```
