REGISTRY := rg.fr-par.scw.cloud
NAMESPACE := decidim
VERSION := latest
IMAGE_NAME := osp-decidim
BUILD_IMAGE_NAME := osp-decidim-base
BASE_BUILD_TAG := $(REGISTRY)/$(NAMESPACE)/$(BUILD_IMAGE_NAME):$(VERSION)
TAG := $(REGISTRY)/$(NAMESPACE)/$(IMAGE_NAME):$(VERSION)

login:
	docker login $(REGISTRY) -u nologin -p $(SCW_SECRET_TOKEN)

build:
	 docker build . --compress -t $(TAG)

build-base:
	 docker build --compress -t $(BASE_BUILD_TAG) - < Dockerfile.build

push:
	docker push $(TAG)

push-base:
	docker push $(BASE_BUILD_TAG)

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

dashboard:
	open http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=default
	@make proxy
