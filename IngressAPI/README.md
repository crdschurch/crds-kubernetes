# IngressAPI

This directory contains the files necessary to deploy the api ingress for the back end applications available at api-{env}.crossroads.net. The function of each file is as follows:

- api-configmap.yml - overrides the default NGINX configuration for the api-ingress controller. The SSL cipher suites are configured to allow communication with the mp-web-vms. (This file may need changed when the NGINX image is updated in the deployment file)
- deployment.yml - specifies a kubernetes deployment for the ingress
- rules.yml - specifies routes for the ingress
- service.yml - specifies the service layer for the ingress

The applications can be reached at api.crossroads.net/{service_name}.