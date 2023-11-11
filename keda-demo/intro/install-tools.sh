#!/bin/bash

install_repos(){
  helm repo add strimzi https://strimzi.io/charts/
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo add kedacore https://kedacore.github.io/charts
  helm repo add marthydavid https://marthydavid.github.io/helm-charts
  helm repo update
}

install_operators(){
echo "Install Prometheus-operator:"
cat > /tmp/kube-prometheus-values.yaml <<EOF
kubeApiServer:
  enabled: false
kubelet:
  eanabled: false
kubeControllerManager:
  enabled: false
coreDns:
  enabled: false
kubeDns:
  enabled: false
kubeEtcd:
  enabled: false
kubeScheduler:
  enabled: false
kubeProxy:
  enabled: false
kubeStateMetrics:
  enabled: false
nodeExporter:
  enabled: false
alertmanager:
  enabled: false
prometheusOperator:
  enabled: true
EOF

helm upgrade --install kube-prometheus-stack --namespace monitoring --create-namespace prometheus-community/kube-prometheus-stack -f /tmp/kube-prometheus-values.yaml
helm upgrade --install strimzi-kafka-operator -n strimzi-system --create-namespace strimzi/strimzi-kafka-operator
helm upgrade --install keda -n keda --create-namespace kedacore/keda
helm upgrade --install producer -n demo --create-namespace marthydavid/producer --set replicaCount=0
helm upgrade --install consumer -n demo --create-namespace marthydavid/consumer --set replicaCount=0
}



install_repos
install_operators