# TeamCity scripts
The ClusterDeployCommandLine file is a list of the AZ commands needed to set up the cluster from scratch.
These commands will work fine if run multiple times and will not fail if the requested resources already exist. This script is run as the first build step in our Kubernetes Project on TeamCity, and is then inherited in each specific environments (Integration, Demo, Prod) deployment configuration. To modify the deployment, change the script at `<RootProject> > Infrastructure > Kubernetes > KubernetesInfrastructureDeploy`. Please update the script here in source control as changes are made in TeamCity.


# az group create --location ""%LOCATION%"" --name "%env.KUBERNETES_RESOURCE_GROUP%" --subscription "%AZURE_SUBSCRIPTION%"
    Creates the resource group that we will store assets in


#  az network vnet create --name "%env.KUBERNETES_RESOURCE_GROUP%-vnet" --resource-group "%env.KUBERNETES_RESOURCE_GROUP%" --location ""%LOCATION%"" --address-prefixes "10.0.0.0/18"
    Creates the virtual network


# az aks create --resource-group "%env.KUBERNETES_RESOURCE_GROUP%" --name "%KUBERNETES_SERVER_NAME%" --kubernetes-version "%env.K8S_VERSION%" --max-pods 50 --network-plugin "azure" --node-count 3 --node-vm-size "Standard_DS3_v2" --nodepool-name "agentpool" --location ""%LOCATION%"" --client-secret "%env.CLIENT_SECRET%" --service-principal "%env.CLIENT_ID%" --dns-service-ip "10.0.0.10"  --docker-bridge-address "172.17.0.1/16" --service-cidr "10.0.0.0/21" --admin-username "crdsadmin" --ssh-key-value "%env.SSH_PUBLICKEY%" 
Creates the K8S cluster with all of it's default settings


# az network public-ip create --name "%env.CROSSROADS_IP_NAME%" --resource-group "MC_%env.KUBERNETES_RESOURCE_GROUP%_%KUBERNETES_SERVER_NAME%_"%LOCATION%"" --allocation-method "Static" --location ""%LOCATION%"" --sku "Standard"
# az network public-ip create --name %env."API_IP_NAME%" --resource-group "MC_%env.KUBERNETES_RESOURCE_GROUP%_%KUBERNETES_SERVER_NAME%_"%LOCATION%"" --allocation-method "Static" --location ""%LOCATION%"" --sku "Standard"
Creates the IP addresses for the API and Frontdoor (crossroads) sites

# bash /home/teamcity/update-az-ip-environment-var.sh "%env.KUBERNETES_RESOURCE_GROUP%_%KUBERNETES_SERVER_NAME%" %env.API_IP_NAME% "env.API_IP" "%env.TEAMCITY_SERVICE_ACCOUNT%" "%env.TEAMCITY_SERVICE_PASSWORD%"
Pulls the new IP we just created and updates the proper environment variable with that IP so that future steps can use it to deploy code. The password for the ServiceAccount is stored in 1Password

# bash /home/teamcity/update-az-ip-environment-var.sh "%env.KUBERNETES_RESOURCE_GROUP%_%KUBERNETES_SERVER_NAME%" "%env.CROSSROADS_IP_NAME%" "env.CROSSROADS_NET_IP" "%env.TEAMCITY_SERVICE_ACCOUNT%" "%env.TEAMCITY_SERVICE_PASSWORD%"
Pulls the new IP we just created and updates the proper environment variable with that IP so that future steps can use it to deploy code. The password for the ServiceAccount is stored in 1Password


# LinuxIPScript
A file has been created in the root folder for the TeamCity user on the build agent called "update-az-ip-environment-var.sh" This file contains what you see in the LinuxIPScript.txt file. The point of this script is to query AZ for the given IP, then push that data back into TeamCity using the TC rest APIs. 