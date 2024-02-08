# ArgoCD

## Installation

[Helm](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd)

```bash
# Install ArgoCD CLI
sudo su
# AMD Architecture
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

# Install ArgoCD
mkdir argocd
cd argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm pull argo/argo-cd
# Number X, Y, Z can be changed
tar -xvzf argo-cd-X.Y.Z.tgz
rm -rf argo-cd-X.Y.Z.tgz

cd argo-cd
cp values.yaml my-values.yaml
vim my-values.yaml
# Customize Vault Helm Chart(values.yaml)

helm install -n argocd argocd --create-namespace -f my-values.yaml .
kubectl get pod -n argocd

kubectl apply -f ingress.yaml

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
# Save Initial Password
```