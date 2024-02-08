# Vault + Kubernetes

## Installation

[Helm](https://developer.hashicorp.com/vault/docs/platform/k8s/helm)

```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm search repo hashicorp/vault
helm pull hashicorp/vault

# Number X, Y, Z can be changed
tar -xvzf vault-X.Y.Z.tgz
vim vault/values.yaml
# Customize Vault Helm Chart(values.yaml)
helm install -n vault --create-namespace vault hashicorp/vault -f vault/values.yaml
```

## Configuration

Kubernetes Pod -> Kubernetes ServiceAccount -> Vault Role -> Vault Policy -> Vault Secret (KV-2 = Key/Vaule Version 2)

```bash
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

exit
```