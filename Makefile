REGISTRY := rg.fr-par.scw.cloud
NAMESPACE := decidim
VERSION := latest
IMAGE_NAME := osp-decidim
TAG := $(REGISTRY)/$(NAMESPACE)/$(IMAGE_NAME):$(VERSION)

login:
	docker login $(REGISTRY) -u nologin -p $(SCW_SECRET_TOKEN)

build:
	 docker build .  --compress -t $(TAG)

push:
	docker push $(TAG)

release:
	@make build
	@make push

ssh:
	kubectl exec -it decidim-k8s-terminal-pod -- /bin/bash

kill-terminal:
	kubectl delete pod decidim-k8s-terminal-pod --ignore-not-found

console:
	kubectl exec -it decidim-k8s-terminal-pod -- bundle exec rails console -e production

migration:
	kubectl delete job decidim-k8s-migration-job --ignore-not-found
	kubectl apply -f kubeconfig/base/migration-job.yaml

rolling-update:
	kubectl rollout restart deployment

proxy:
	kubectl proxy

apply-production:
	kubectl apply -k kubeconfig/overlays/production

apply-staging:
	kubectl apply -k kubeconfig/overlays/staging

setup:
	kubectl apply -f kubeconfig/base/secrets.yml
	helm repo add jetstack https://charts.jetstack.io
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update
	helm install redis-cluster bitnami/redis \
	  --set auth.enabled=false \
      --set cluster.slaveCount=3 \
      --set securityContext.enabled=true \
      --set securityContext.fsGroup=2000 \
      --set securityContext.runAsUser=1000 \
      --set volumePermissions.enabled=true \
      --set master.persistence.enabled=true \
      --set master.persistence.path=/data \
      --set master.persistence.size=8Gi \
      --set master.persistence.storageClass="scw-bssd-retain" \
      --set slave.persistence.enabled=true \
      --set slave.persistence.path=/data \
      --set slave.persistence.size=8Gi \
      --set slave.persistence.storageClass="scw-bssd-retain"
	helm install \
      cert-manager jetstack/cert-manager \
      --namespace cert-manager \
      --create-namespace \
      --version v1.6.1 \
      --set installCRDs=true

dump_secret:
	kubectl get secret decidim-k8s-app-secrets -o yaml > $$(pwd)/kubeconfig/base/secrets.yml

dashboard:
	open http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=default
	@make proxy
