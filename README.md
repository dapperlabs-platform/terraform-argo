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
