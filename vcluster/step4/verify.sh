#!/bin/bash
export KUBECONFIG=/root/.kube/config
kubectl --context default -n vcluster-test-v1-28 wait --for=condition=ready pods/test-v1-28-0