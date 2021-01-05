# crds-kubernetes
Kubernetes Infrastructure for Crossroads

# Purpose

This repository contains all of the files used to set up the crossroads environment on a kubernetes cluster. This repository is deployed via our CI/CD pipeline (currently teamcity under the infrastructure/kubernetes project). Any environment variables seen in the files are replaced during the build and deploy process in TeamCity.

# Namespaces

The kubernetes cluster is broken into 3 separate namespaces. Each namespace contains it's own ingress controller and external IP address.

### Default

This namespace contains any front end applications and the routing to those applications via an ingress controller.

### API

This namespace contains back end applications and the routing to those applications via an ingress controller.

### kube-system

This namespace is built into the kubernetes deployment and contains some system applications. It also contains an ingress that exposes the kubernetes dashboard.


### Updating SSL Certificates
This was the process to update certs prior to automation added in Jan 21. The current certs stored in this location expire Oct 2021.

To update SSL Certificates:
SSH into the Linux Build VM

Update the `chain.crt`, `tls.crt`, `tls.key` files under /data/teamcity/ssl - `scp file.ext user@ci.crossroads.net:/data/teamcity/ssl`

Redeploy the Kubernetes project in TeamCity

Delete and restart the api-ingress pods

### Updating SSL CERTS post 1/1/21 ###
The CertManager deployment downloads a cert manager from github and adds new k8s types. Then applies all of the files needed to automates the cert renewal process through letsencrypt. The cert information is stored on a volume with in the cluster.

 The api-ssl-issuer.yml file is applied as a part of the crds-kubernetes deployment.

The automation was added to all the k8s environments, but currently is only creating certs for the api ingress.