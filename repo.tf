
locals {
  okta_api_data = jsondecode(data.google_secret_manager_secret_version.okta_api.secret_data)
  repos         = transpose({ for repo in var.git_repos : repo.org => repo.names })
}

resource "tls_private_key" "rsa_4096" {
  for_each  = { for repo in var.git_repos : repo.org => repo.org }
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "github_repository_deploy_key" "deploy_keys" {
  for_each   = local.repos
  title      = var.project
  repository = "${one(each.value)}/${each.key}"
  key        = tls_private_key.rsa_4096[one(each.value)].public_key_openssh
  read_only  = "true"
}

resource "kubernetes_secret" "org_cred" {
  for_each = { for repo in var.git_repos : repo.org => repo.org }

  metadata {
    name      = "${each.key}-org-cred"
    namespace = var.argo.release_namespace

    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }

  data = {
    "url"           = "git@github:${each.key}"
    "sshPrivateKey" = tls_private_key.rsa_4096[each.key].private_key_openssh
  }
}

resource "kubernetes_secret" "repos" {
  for_each = local.repos

  metadata {
    name      = "${each.key}-repo"
    namespace = var.argo.release_namespace

    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    "type" = "git"
    "url"  = "git@github:${one(each.value)}/${each.key}.git"
  }
}
