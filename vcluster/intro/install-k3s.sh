set -x
echo starting...

k3s_version="v1.24.7+k3s1"
systemctl disable --now systemd-resolved
mkdir -p /etc/rancher/k3s
mkdir -p /var/lib/rancher/k3s/server/manifests

cat > /etc/rancher/k3s/config.yaml <<EOF
write-kubeconfig-mode: "0644"
disable:
  - traefik
  - servicelb
EOF

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --cluster-init" INSTALL_K3S_VERSION=${k3s_version} sh -

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