#!/bin/bash
# Encodes the environment variables into a Kubernetes secret.

AUTH_USERNAME=$(echo -n ${KUBERNETES_DASHBOARD_USERNAME})
AUTH_PASSWORD=$(openssl passwd -apr1 $KUBERNETES_DASHBOARD_PASSWORD)
AUTH_PLACEHOLDER="$AUTH_USERNAME:$AUTH_PASSWORD"
sed -e "s#{{auth_placeholder}}#${AUTH_PLACEHOLDER}#g" ./dashboard-htpasswd-template.yml > dashboard-htpasswd.yml
