#!/bin/bash
export KUBECONFIG=/root/.kube/config
kubectl --context vcluster_test_vcluster-test_default get crds|grep -q cert-manager