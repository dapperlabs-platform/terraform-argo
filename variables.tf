variable "project" {
  description = "Project name"
  type        = string
}

variable "cluster" {
  description = "Cluster name and location"
  type = object({
    name     = string
    location = string
  })
}

variable "git_repos" {
  description = "List of repositories to create deploy keys assuming under same org"
  type = list(object({
    org = string
    names = list(string)
  }))
}

variable "okta_api_gsm" {
  description = "GSM secret for Okta API key-pair that has json format with keys [client_id, client_secret]"
  type = object({
    secret  = string
    project = string
  })
}

variable "argo" {
  description = "Argo helm chart info"
  type = object({
    chart_location    = string
    values_location   = string
    release_namespace = string
  })
}
