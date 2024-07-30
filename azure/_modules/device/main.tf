resource "azurerm_resource_group" "TerraFailIoTHub_rg" {
  name     = "TerraFailIoTHub_rg"
  location = "East US"
}

# ---------------------------------------------------------------------
# DNS
# ---------------------------------------------------------------------
resource "azurerm_iothub" "TerraFailIoTHub" {
  name                = "TerraFailIoTHub"
  resource_group_name = azurerm_resource_group.TerraFailIoTHub_rg.name
  location            = azurerm_resource_group.TerraFailIoTHub_rg.location

  sku {
    name     = "S1"
    capacity = "1"
  }

  public_network_access_enabled = true
  min_tls_version               = 1.2

  network_rule_set {
    default_action = "Allow"
    ip_rule {
      name    = "wildcard"
      ip_mask = "0.0.0.0/0"
    # Drata: Ensure that [azurerm_iothub.network_rule_set.ip_rule.ip_mask] is explicitly defined and narrowly scoped to only allow trusted sources to access IoT Hub
    }
  }
}
