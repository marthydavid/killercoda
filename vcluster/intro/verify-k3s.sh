echo waiting for k3s installation to finish
while [ ! -f /usr/local/bin/kubectl ]; do sleep 1; done
sleep 60
kubectl -n metallb-system wait --for condition=Available=True deployment/metallb-controller --timeout=120s
echo K3s and other components installed and should run