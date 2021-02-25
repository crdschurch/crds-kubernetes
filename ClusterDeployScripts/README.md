# TeamCity scripts
The ClusterDeployCommandLine file is a list of the AZ commands needed to set up the cluster from scratch.
These commands will work fine if run multiple times and will not fail if the requested resources already exist


# az group create --location "eastus" --name "%env.KUBERNETES_RESOURCE_GROUP%" --subscription "%AZURE_SUBSCRIPTION%"
    Creates the resource group that we will store assets in


#  az network vnet create --name "%env.KUBERNETES_RESOURCE_GROUP%-vnet" --resource-group "%env.KUBERNETES_RESOURCE_GROUP%" --location "eastus" --address-prefixes "10.0.0.0/18"
    Creates the virtual network


# az aks create --resource-group "%env.KUBERNETES_RESOURCE_GROUP%" --name "%KUBERNETES_SERVER_NAME%" --kubernetes-version "%env.K8S_VERSION%" --max-pods 50 --network-plugin "azure" --node-count 3 --node-vm-size "Standard_DS3_v2" --nodepool-name "agentpool" --location "eastus" --client-secret "%env.CLIENT_SECRET%" --service-principal "%env.CLIENT_ID%" --dns-service-ip "10.0.0.10"  --docker-bridge-address "172.17.0.1/16" --service-cidr "10.0.0.0/21" --admin-username "crdsadmin" --ssh-key-value "%env.SSH_PUBLICKEY%" 
Creates the K8S cluster with all of it's default settings


# az network public-ip create --name "crossroads-int" --resource-group "MC_%env.KUBERNETES_RESOURCE_GROUP%_%KUBERNETES_SERVER_NAME%_eastus" --allocation-method "Static" --location "eastus" --sku "Standard"
# az network public-ip create --name "api-int" --resource-group "MC_%env.KUBERNETES_RESOURCE_GROUP%_%KUBERNETES_SERVER_NAME%_eastus" --allocation-method "Static" --location "eastus" --sku "Standard"
Creates the IP addresses for the API and Frontdoor (crossroads) sites

# bash /home/teamcity/update-az-ip-environment-var.sh "%env.KUBERNETES_RESOURCE_GROUP%_%KUBERNETES_SERVER_NAME%" "api-int" "env.API_IP" "%env.TEAMCITY_SERVICE_ACCOUNT%" "%env.TEAMCITY_SERVICE_PASSWORD%"
Pulls the new IP we just created and updates the proper environment variable with that IP so that future steps can use it to deploy code. The password for the ServiceAccount is stored in 1Password

# bash /home/teamcity/update-az-ip-environment-var.sh "%env.KUBERNETES_RESOURCE_GROUP%_%KUBERNETES_SERVER_NAME%" "crossroads-int" "env.CROSSROADS_NET_IP" "%env.TEAMCITY_SERVICE_ACCOUNT%" "%env.TEAMCITY_SERVICE_PASSWORD%"
Pulls the new IP we just created and updates the proper environment variable with that IP so that future steps can use it to deploy code. The password for the ServiceAccount is stored in 1Password



# LinuxIPScript
A file has been created in the root folder for the TeamCity user on the build agent called "update-az-ip-environment-var.sh" This file contains what you see in the LinuxIPScript.txt file. The point of this script is to query AZ for the given IP, then push that data back into TeamCity using the TC rest APIs. 


