
data "google_secret_manager_secret_version" "okta_api" {
  secret  = var.okta_api_gsm.secret
  project = var.okta_api_gsm.project
}

resource "helm_release" "argocd" {
  name             = "argocd"
  chart            = var.argo.chart_location
  namespace        = var.argo.release_namespace
  create_namespace = true

  values = [
    "${file(var.argo.values_location)}"
  ]

  set {
    name  = "okta.client_id"
    value = local.okta_api_data.client_id
  }

  set {
    name  = "okta.client_secret"
    value = local.okta_api_data.client_secret
  }
}

