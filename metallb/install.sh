#!/bin/bash
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.3/config/manifests/metallb-native.yaml

mkdir -p $HOME/Projects/metallb
cat <<EOF | sudo tee $HOME/Projects/metallb/config.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default
  namespace: metallb-system
spec:
  addresses:
	# 파랑 부분 수정 (본인이 외부 접속용으로 사용할 고정IP 범위로 지정)
  - 115.145.150.214-115.145.150.216
  autoAssign: true
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: metallb-system
spec:
  ipAddressPools:
  - default
EOF

kubectl delete validatingwebhookconfigurations metallb-webhook-configuration
kubectl apply -f $HOME/Projects/metallb/config.yaml