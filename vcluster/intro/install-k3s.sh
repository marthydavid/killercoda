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
  - servicelb
EOF

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --cluster-init" INSTALL_K3S_VERSION=${k3s_version} sh -
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
chmod 0600 /root/.kube/config

cat > /var/lib/rancher/k3s/server/manifests/00-metallb-helmchart.yaml <<EOF
---
apiVersion: v1
kind: Namespace
metadata:
  name: metallb-system
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: metallb
  namespace: metallb-system
spec:
  repo: https://metallb.github.io/metallb
  chart: metallb
  set:
    global.systemDefaultRegistry: ""
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 198.51.100.0/24
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
EOF