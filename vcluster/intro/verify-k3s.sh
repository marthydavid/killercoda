echo waiting for k3s installation to finish
while [ ! -f /var/lib/rancher/k3s/server/manifests/00-metallb-helmchart.yaml ]; do sleep 1; done
echo K3s installed and should run