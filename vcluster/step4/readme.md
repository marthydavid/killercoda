# Install 2nd vcluster

Check current-context

`kubectl config current-context`{{exec}}

It should show: `vcluster_test_vcluster-test_default`

## Disconnect test:

```
vcluster disconnect
```{{exec}}

```
kubectl cluster-info
```{{exec}}

```
vcluster create test-v1-20 --kubernetes-version v1.20
```{{exec}}


Open a new terminal:

```
export KUBECONFIG=/root/.kube/config
kubectl version -oyaml
```{{exec}}

```
kubectl --context default version -oyaml
```{{exec}}