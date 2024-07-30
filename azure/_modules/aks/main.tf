resource "azurerm_resource_group" "TerraFailAKS_rg" {
  name     = "TerraFailAKS_rg"
  location = "East US 2"
}

# ---------------------------------------------------------------------
# AKS
# ---------------------------------------------------------------------
resource "azurerm_kubernetes_cluster" "TerraFailAKS_cluster" {
  # Drata: Set [azurerm_kubernetes_cluster.role_based_access_control_enabled] to [true] to configure resource authentication using role based access control (RBAC). RBAC allows for more granularity when defining permissions for users and workloads that can access a resource. Set [microsoft_container_service.managed_clusters.disable_local_accounts] to true to restrict access to your cluster through local admin accounts. If configuring this setting on an existing cluster, be sure to rotate cluster certificates to revoke any certificates that previously authenticated users may have had access to
  name                = "TerraFailAKS_cluster"
  location            = azurerm_resource_group.TerraFailAKS_rg.location
  resource_group_name = azurerm_resource_group.TerraFailAKS_rg.name
  dns_prefix          = "TerraFailAKS_cluster"

  default_node_pool {
    name                = "TerraFailAKS_pool"
    vm_size             = "Standard_D2_v2"
    node_count          = 1
    enable_auto_scaling = false
    zones               = []
  }

  local_account_disabled  = false
  private_cluster_enabled = false

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = false
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "TerraFailAKS_node_pool" {
  name                  = "TerraFailAKS_node_pool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.TerraFailAKS_cluster.id
  vm_size               = "Standard_DS2_v2"
  enable_node_public_ip = true
  enable_auto_scaling   = false
  max_count             = 100
  min_count             = 0
}
