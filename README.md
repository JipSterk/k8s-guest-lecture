## Prerequisites

- if you have [brew](https://brew.sh/) install the following:
  - [docker](https://formulae.brew.sh/cask/docker#default)
  - [kubernetes-cli](https://formulae.brew.sh/formula/kubernetes-cli#default)
  - [doctl](https://formulae.brew.sh/formula/doctl#default)

## Deploy your website

### On your digital ocean account

- create a new cluster [here](https://cloud.digitalocean.com/kubernetes/clusters/new)
  - select `AMS3`
  - for the node plan select the $18 with 2GB RAM / 2 vCPUs / 60GB
  - set a name for the node pool name such as `staging`
  - set nodes to 1
  - set name to your applications name
  - click `Marketplace`
    - install `NGINX Ingress Controller` & `Cert-Manager`
- login where you bought your domain name
  - follow digital ocean's documentation [here](https://docs.digitalocean.com/products/networking/dns/getting-started/dns-registrars/) on how to setup their nameserver
  - go to [domains](https://cloud.digitalocean.com/networking/domains) in digital coean
  - create new `A` record
    - for the domain just use `@` to specify that you don't want a subdomain, if you do type the name e.g. `k8s-guest-lecture` to end up with k8s-guest-lecture.<your-domain>.nl/com
    - from the dropdown select the load balancer created by the `NGINX Ingress Controller`
    - set TTL to 60 (1 minute)

### On your computer

- run `kubectl create namespace hu` to create a namespace
- run the following command to create the `ghcr-secret` thats used to pull images from the github container registry:

```sh
kubectl create secret docker-registry ghcr-secret \
  --namespace=hu \
  --docker-server=ghcr.io \
  --docker-username=<your github account username> \
  --docker-password=<a github [token](https://github.com/settings/tokens/new) with the following scopes: `write:packages`> \
  --docker-email=<the email used for the username>
```

- run the following command to setup the certificate issuer:

```sh
kubectl apply -f ./k8s/certificate-issuer.yaml
```

- run the following command to setup ingress instance for the deployment:

```sh
kubectl apply -f ./k8s/certificate-ingress.yaml
```

- run the following command to setup the deployment:

```sh
kubectl apply -f ./k8s/deployment.yaml
```

- run the following command to setup the service:

```sh
kubectl apply -f ./k8s/service.yaml
```
