resource "azuread_application" "client" {
  name       = "var.client_application_name
  reply_urls = ["http://k8s_client"]
  type       = "native"

  required_resource_access {
    # Windows Azure Active Directory API
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    resource_access {
      # DELEGATED PERMISSIONS: "Sign in and read user profile":
      # 311a71cc-e848-46a1-bdf8-97ff7156d8e6
      id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
      type = "Scope"
    }
  }

  required_resource_access {
    # AKS ad application server
    resource_app_id = azuread_application.server.application_id

    resource_access {
      # Server app Oauth2 permissions id
      id   = lookup(azuread_application.server.oauth2_permissions[0], "id")
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "client" {
  application_id = azuread_application.client.application_id
}

resource "azuread_service_principal_password" "client" {
  service_principal_id = azuread_service_principal.client.id
  value                = random_string.application_client_password.result
  end_date             = timeadd(timestamp(), "87600h")

  lifecycle {
    ignore_changes = [end_date]
  }
}

resource "random_string" "application_client_password" {
  length  = 16
  special = true

  keepers = {
    service_principal = azuread_service_principal.client.id
  }
}

# https://github.com/terraform-providers/terraform-provider-azuread/issues/104
resource "null_resource" "grant_client_admin_consent" {
  provisioner "local-exec" {
    command = "az ad app permission admin-consent --id ${azuread_application.client.application_id}"
  }
}