resource "azuread_application" "server" {
  name                    = var.server_application_name
  reply_urls              = ["http://k8s_server"]
  type                    = "webapp/api"
  group_membership_claims = "All"

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
    # MicrosoftGraph API
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    # APPLICATION PERMISSIONS: "Read directory data":
    # 7ab1d382-f21e-4acd-a863-ba3e13f7da61
    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"
      type = "Role"
    }

    # DELEGATED PERMISSIONS: "Sign in and read user profile":
    # e1fe6dd8-ba31-4d61-89e7-88639da4683d
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }

    # DELEGATED PERMISSIONS: "Read directory data":
    # 06da0dbc-49e2-44d2-8312-53f166ab848a
    resource_access {
      id   = "06da0dbc-49e2-44d2-8312-53f166ab848a"
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "server" {
  application_id = azuread_application.server.application_id
}

resource "azuread_service_principal_password" "server" {
  service_principal_id = azuread_service_principal.server.id
  value                = random_string.application_server_password.result
  end_date             = timeadd(timestamp(), "87600h")

  lifecycle {
    ignore_changes = [end_date]
  }
}

resource "random_string" "application_server_password" {
  length  = 16
  special = true

  keepers = {
    service_principal = azuread_service_principal.server.id
  }
}

# https://github.com/terraform-providers/terraform-provider-azuread/issues/104
resource "null_resource" "grant_server_admin_consent" {
  provisioner "local-exec" {
    command = "az ad app permission admin-consent --id ${azuread_application.server.application_id}"
  }
}