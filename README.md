# Lingua Greeter GitOps

This repository act as GitOps repo for the <https://github.com/kameshsampath/lingua-greeter> app.

## Prerequisites

- [Docker for Mac/Windows/Linux](https://www.docker.com/products/docker-desktop)
- [httpie](https://httpie.org/)
- [kustomize](https://kustomize.io/)
- [Drone CLI](https://docs.drone.io/cli/install/)
- [k3d](https://k3d.io)
- [direnv](https://direnv.net)(optional)

## Google Cloud Account

You also need Google Cloud [Service Account Key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) with Translation API enabled.

The application uses [Google Cloud Translation API](https://cloud.google.com/translate/docs/quickstarts).

## Setup DRAG

You need a environment that can help you do CI and GitOps. You can setup one locally as described here <https://github.com/kameshsampath/drag-stack.git>.

```shell
drone exec --trusted
```

Extract `kubeconfig`,

```shell
mkdir -p "${APP_GITOPS_HOME}/.kube"
k3d kubeconfig get "${K3D_CLUSTER_NAME}" > "${KUBECONFIG}"
```

Update the Kube API Server,

```shell
sed -i 's|host.docker.internal|127.0.0.1|' "${KUBECONFIG}"
```

Ensure your are able query the clusters.

```shell
kubectl get pods -n kube-system
```

## GitOps

Update the App helm `$APP_GITOPS_HOME/helm_vars/values.yaml`

```shell
envsubst < "$APP_GITOPS_HOME/helm_vars/values.tpl.yaml" > "$APP_GITOPS_HOME/helm_vars/values.yaml"
```

Commit and push the code to git repo,

```shell
git commit -a -m "Init GitOps"
git push origin main
```

**NOTE**: Please use the right git remote as per your settings

Deploy Argo CD application Kubernetes cluster that will use our GitOps repo,

```shell
kustomize build "$APP_GITOPS_HOME"| envsubst | kubectl apply -f -
```
