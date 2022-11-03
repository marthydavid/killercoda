# Install cluster wide resources

Configure kubeconfig:
`export KUBECONFIG=$HOME/.kube/config`{{exec}}

Check current-context

`kubectl config current-context`{{exec}}

It should show: `vcluster_test_vcluster-test_default`

## Install cert-manager:

```
helm repo add jetstack https://charts.jetstack.io
helm repo update
```{{exec}}

```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.0/cert-manager.crds.yaml
```{{exec}}

```
kubectl get crds|grep cert-manager
```{{exec}}

Check crds on hosting cluster:

```
kubectl --context default get crds|grep cert-manager
```{{exec}}


Run the helm install command:

```
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.10.0
```{{exec}}

Check running pods:

```
kubectl get pods -n cert-manager
```{{exec}}


Check separation on the hosting cluster:
```
kubectl --context default get pods -n vcluster-test
```{{exec}}