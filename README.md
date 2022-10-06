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
./hack/setup.sh
```

Ensure your are able query the clusters.

```shell
kubectl get pods -n kube-system
```

## Creating Google Application SA Secret

As the demo application relies on Google Cloud SA JSON, let us create that manually.

```shell
kubectl create ns demo-apps
```

```shell
kubectl create secret generic -n demo-apps google-cloud-creds --from-file="google-cloud-credentials.json=${GOOGLE_APPLICATION_CREDENTIALS}"
```

**NOTE**: This step is manually done to avoid any accidental check in of the SA JSON file

## GitOps

Update the App helm `$APP_GITOPS_HOME/helm_vars/values.yaml`

```shell
envsubst < "$APP_GITOPS_HOME/helm_vars/values.tpl.yaml" > "$APP_GITOPS_HOME/helm_vars/values.yaml"
```

Commit and push the code to git repo,

```shell
git commit -a -m "Init GitOps"
git push origin demo
```

**NOTE**: Please use the right git remote as per your settings

Deploy Argo CD application Kubernetes cluster that will use our GitOps repo,

```shell
kustomize build "$APP_GITOPS_HOME/k8s/argo-app" | envsubst | kubectl apply -f -
```

## Clean up

```shell
./hack/cleanup.sh
```
