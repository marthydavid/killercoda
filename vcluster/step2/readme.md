Access the first vcluster

`export KUBECONFIG=$HOME/.kube/config`{{exec}}

See cluster info before vcluster access
`kubectl cluster-info`{{exec}}

`vcluster connect test`{{exec}}

And after vcluster access
`kubectl cluster-info`{{exec}}

Run workload on vcluster

`kubectl run nginx --image=nginx`{{exec}}
