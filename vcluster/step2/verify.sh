#!/bin/bash

export KUBECONFIG=/root/.kube/config

kubectl --context default get ns vcluster-test
kubectl --context default wait --for=condition=ready -n vcluster-test pod/nginx-x-default-x-test