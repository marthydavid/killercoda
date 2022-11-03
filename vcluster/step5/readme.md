# Install ingress-nginx on vcluster

On tab1 exit vcluster


`kubectl config current-context`{{exec}}

It should show: `default`

## Disconnect test:

```
vcluster connect test
```{{exec}}

```
kubectl cluster-info
```{{exec}}

Add ingress-nginx helm repo:

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```{{exec}}


Install ingress-nginx:

```
helm upgrade --install \
  ingress-nginx \
  --create-namespace \
  --namespace ingress-nginx \
  ingress-nginx/ingress-nginx
```{{exec}}

```
kubectl --context default version -oyaml
```{{exec}}

```
kubectl apply -f - <<EOF
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-cluster-issuer
spec:
  selfSigned: {}
EOF
```{{exec}}

```
helm repo add k8s-at-home https://k8s-at-home.com/charts/
helm repo update
```{{exec}}

```
cat <<EOF> nullserv.yaml
ingress:
  main:
    # -- Enables or disables the ingress
    enabled: true
    ingressClassName: "nginx"
    annotations:
      cert-manager.io/cluster-issuer: selfsigned-cluster-issuer
    hosts:
      - host: nullserv.198.51.100.1.nip.io
        paths:
          -  # -- Path.  Helm template can be passed.
            path: /
            # -- Ignored if not kubeVersion >= 1.14-0
            pathType: Prefix
    tls:
      - hosts:
          - nullserv.198.51.100.1.nip.io
        secretName: nullserv-tls
EOF
helm upgrade --install nullserv k8s-at-home/nullserv -f nullserv.yaml --wait
```{{exec}}

```
curl -Lkv http://nullserv.198.51.100.1.nip.io
```{{exec}}


