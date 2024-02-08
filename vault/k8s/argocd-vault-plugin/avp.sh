#!/bin/bash

kubectl exec -it -n vault vault-0 -- sh

vault operator init
# Save Unseal Key, Initial Root Token

# At least 3 times
vault operator unseal
vault operator unseal
vault operator unseal

vault login

vault secrets enable kv-v2
vault secrets enable kubernetes
vault auth enable kubernetes

env | grep KUBERNETES
ls -al /var/run/secrets/kubernetes.io/serviceaccount/

# Create KV-2 Secret, Policy (Example)
vault kv put kv/data/kv-v2/admin user="secret_user" password="secret_password"
vault policy write admin - <<EOF
path "kv/data/kv-v2/admin" {
  capabilities = ["read"]
}
EOF

vault write auth/kubernetes/config token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
vault write auth/kubernetes/role/argocd bound_service_account_names=argocd-repo-server bound_service_account_namespaces=argocd policies=admin ttl=48h

exit

kubectl apply -f configmap.yaml
kubectl apply -f secrey.yaml
kubectl edit -n argocd deployment argocd-repo-server