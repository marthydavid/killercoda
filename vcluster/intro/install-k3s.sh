set -x
echo starting...

k3s_version="v1.24.7+k3s1"

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

curl -L -o /usr/local/bin/vcluster "https://github.com/loft-sh/vcluster/releases/latest/download/vcluster-linux-amd64"

chmod 0755 /usr/local/bin/vcluster
systemctl disable --now systemd-resolved
mkdir -p /etc/rancher/k3s
mkdir -p /root/.kube
mkdir -p /var/lib/rancher/k3s/server/manifests

cat > /etc/rancher/k3s/config.yaml <<EOF
write-kubeconfig-mode: "0644"
disable:
  - traefik
EOF

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --cluster-init" INSTALL_K3S_VERSION=${k3s_version} sh -
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
cat > /var/lib/rancher/k3s/server/manifests/00-ingress-nginx-helmchart.yaml <<EOF
---
apiVersion: v1
kind: Namespace
metadata:
  name: ingress-nginx
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: ingress-nginx
  namespace: ingress-nginx
spec:
  repo: https://kubernetes.github.io/ingress-nginx
  chart: ingress-nginx
  set:
    global.systemDefaultRegistry: ""
  valuesContent: |-
    controller:
      kind: DaemonSet
      ingressClassResource:
        default: true
      hostNetwork: true
EOF

