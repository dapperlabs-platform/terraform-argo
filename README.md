# argo-modules
Argo Common Modules and Libraries

## How to use it

```hcl
module "argo" {
  source  = "github.com/dapperlabs-platform/terraform-argo?ref=<latest-tag>"
  project = "dl-sre-staging"

  cluster = {
    location = "us-west1"
    name     = "us-west1-application"
  }

  git_repos = [{ org = "dapperlabs", names = ["dapperlabs-sre-infrastructure", "sre-operator"] }]

  okta_api_gsm = {
    project = "dl-sre-staging"
    secret  = "okta-api"
  }

  argo = {
    chart_location    = "../k8s/sre/argo/helm"
    release_namespace = "argocd"
    values_location   = "../k8s/sre/argo/helm/staging.yaml"
  }
}
```

## Okta API-Keys

- Setup Okta OIDC API-keys with IT
- Create a GSM secret version with the keys in json structure:

```hcl
resource "google_secret_manager_secret_version" "latest" {
  secret = google_secret_manager_secret.okta_api.id
  secret_data = jsonencode({
    client_id     = "client_id"
    client_secret = "client_secret"
  })
}
```

## Github API-key

- This module relies on `atlantis` envars for Github access.

```
provider "github" {
  # owner = GITHUB_OWNER environment variable
  # token = GITHUB_TOKEN environment variable
}
```

## Helm chart location

- This module assumes your local helm-chart setup for templating the release, see [sre-infra-example](https://github.com/dapperlabs/dapperlabs-sre-infrastructure/tree/main/k8s/sre/argo/helm)
