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


## Create cluster with different k8s version

```
vcluster create test-v1-28 --kubernetes-version v1.28 --expose
```{{exec}}


Check server version

```
kubectl version -oyaml
```{{exec}}

Check host cluster version

```
kubectl --context default version -oyaml
```{{exec}}