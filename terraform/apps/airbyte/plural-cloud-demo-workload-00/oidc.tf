resource "random_password" "oidc_cookie" {
  length      = 24
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  special     = false
}

resource "plural_oidc_provider" "airbyte" {
  name = "airbyte-plural-cloud-demo-workload-00"
  auth_method = "BASIC"
  type = "PLURAL"
  description = "OIDC provider for airbyte deployed to the plural-cloud-demo-workload-00 cluster"
  redirect_uris = ["https://svc-context-airbyte-test/oauth2/callback"]
}
