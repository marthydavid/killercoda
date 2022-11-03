#!/bin/bash
export KUBECONFIG=/root/.kube/config
kubectl --context default -n vcluster-test-v1-20 wait --for=condition=ready pods/test-v1-20-0