# Access the first vcluster

## Set the correct kubeconfig

With k3s the default would be `/etc/rancher/k3s/k3s.yaml` but we don't want to interfer with that.

```
export KUBECONFIG=$HOME/.kube/config
```{{exec}}

## See cluster info before vcluster access

```
kubectl cluster-info
```{{exec}}

## Connect to the created cluster

```
vcluster connect test
```{{exec}}

## Query cluster info

```
kubectl cluster-info
```{{exec}}

## Run workload on vcluster

```
kubectl run nginx --image=nginx
```{{exec}}

```
kubectl get pods
```{{exec}}

## Check this pod from host cluster perspective

```
kubectl --context default --namespace vcluster-test get pods
```{{exec}}