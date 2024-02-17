# Argocd Vault Plugin

## Installation

[ArgoCD Vault Plugin](https://argocd-vault-plugin.readthedocs.io/en/stable/installation/)

[ArgoCD Vault Plugin - Kustomize Source Code](https://github.com/argoproj-labs/argocd-vault-plugin/tree/main/manifests/cmp-sidecar)

```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm search repo hashicorp/vault
helm pull hashicorp/vault

# Number X, Y, Z can be changed
tar -xvzf vault-X.Y.Z.tgz
sudo rm -rf vault-X.Y.Z.tgz
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

vault write auth/kubernetes/config token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
vault write auth/kubernetes/role/argocd bound_service_account_names=argocd-repo-server bound_service_account_namespaces=argocd policies=admin ttl=48h

exit

kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl edit -n argocd deployment argocd-repo-server
# Reference : deployment.argocd-repo-server.yaml
```

## Usage (Kustomize Project in Git Repo)

#### Project Structure (Example)
```
📦kustomize
 ┣ 📂base
 ┃ ┣ 📜deployment.yaml
 ┃ ┣ 📜ingress.yaml
 ┃ ┣ 📜kustomization.yaml
 ┃ ┗ 📜service.yaml
 ┣ 📂overlays
 ┃ ┣ 📂dev
 ┃ ┃ ┣ 📜domain.json
 ┃ ┃ ┣ 📜kustomization.yaml
 ┃ ┃ ┣ 📜namespace.yaml
 ┃ ┃ ┗ 📜secret.yaml
 ┃ ┗ 📂prod
 ┃ ┃ ┣ 📜domain.json
 ┃ ┃ ┣ 📜kustomization.yaml
 ┃ ┃ ┣ 📜namespace.yaml
 ┃ ┃ ┗ 📜secret.yaml
 ┗ 📜README.md
```
#### Vault Secret -> Kustomize

`vault kv put kv/data/kv-v2/admin user="secret_user" password="secret_password"`
  
  -> To get `user`, use `<path:kv/data/kv-v2/admin#user | base64encode>` in a secret.yaml file
  
  -> To get `password`, use `<path:kv/data/kv-v2/admin#password | base64encode>` in a secret.yaml file

#### kustomization.yaml (overlays/prod)
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: YOUR_NAMESPACE
patches:
- path: domain.json
  target:
    kind: Ingress
    name: ingress
resources:
- ../../base
- namespace.yaml
- secret.yaml
```

#### secret.yaml (overlays/prod)
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: vault-secret
type: Opaque
data:
  DB_USERNAME: <path:kv/data/kv-v2/admin#user | base64encode>
  DB_PASSWORD: <path:kv/data/kv-v2/admin#password | base64encode>
```