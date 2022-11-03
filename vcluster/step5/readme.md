# Install ingress-nginx on vcluster

## Disconnect v1-20

```
vcluster disconnect
```
{{exec interrupt}}

```
kubectl config current-context
```{{exec}}

It should show: `default`

## Reconnect test:

```
vcluster connect test
kubectl config current-context
```{{exec}}

## Install ingress-nginx to server ingress traffic from vcluster

Add ingress-nginx helm repo:

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```{{exec}}

Install chart

```
helm upgrade --install \
  ingress-nginx \
  --create-namespace \
  --namespace ingress-nginx \
  ingress-nginx/ingress-nginx
```{{exec}}

Create certificate issuer for TLS certs

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

## Install application in vcluster with ingress.

Add k8s-at-home repo

```
helm repo add k8s-at-home https://k8s-at-home.com/charts/
helm repo update
```{{exec}}

Create nullserv values file

```
cat <<EOF> nullserv.yaml
ingress:
  main:
    # -- Enables or disables the ingress
    enabled: true
    ingressClassName: "nginx"
    annotations:
      # -- Use the pre-created cluster issuer
      cert-manager.io/cluster-issuer: selfsigned-cluster-issuer
    hosts:
      - host: nullserv.198.51.100.2.nip.io
        paths:
          -  # -- Path.  Helm template can be passed.
            path: /
            # -- Ignored if not kubeVersion >= 1.14-0
            pathType: Prefix
    tls:
      - hosts:
          - nullserv.198.51.100.2.nip.io
        secretName: nullserv-tls
EOF
helm upgrade --install nullserv k8s-at-home/nullserv -f nullserv.yaml --wait
```{{exec}}


## Check application

```
curl -Lkv http://nullserv.198.51.100.2.nip.io
```{{exec}}


```
openssl s_client -connect nullserv.198.51.100.2.nip.io:443 -showcerts|openssl x509 -noout -text -certopt no_subject,no_header,no_version,no_serial,no_signame,no_validity,no_issuer,no_pubkey,no_sigdump,no_aux
```{{exec}}