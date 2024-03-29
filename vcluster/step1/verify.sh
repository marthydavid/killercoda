#!/bin/bash

export KUBECONFIG=/root/.kube/config

kubectl get ns vcluster-test
until kubectl --namespace vcluster-test get svc/test-lb --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do : ; done