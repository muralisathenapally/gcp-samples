resource "google_project_organization_policy" "project_deny_public_ip" {
  count      = var.target_level == "project" ? 1 : 0
  project    = var.target_id
  constraint = "constraints/compute.vmExternalIpAccess"

  list_policy {
    deny {
      all = true
    }
  }
}

resource "google_project_organization_policy" "project_disable_default_network" {
  count      = var.target_level == "project" ? 1 : 0
  project    = var.target_id
  constraint = "constraints/compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = true
  }
}

resource "google_folder_organization_policy" "folder_deny_public_ip" {
  count      = var.target_level == "folder" ? 1 : 0
  folder     = var.target_id
  constraint = "constraints/compute.vmExternalIpAccess"

  list_policy {
    deny {
      all = true
    }
  }
}


resource "google_folder_organization_policy" "folder_disable_default_network" {
  count      = var.target_level == "folder" ? 1 : 0
  folder     = var.target_id
  constraint = "constraints/compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = true
  }
}


resource "google_organization_policy" "org_deny_public_ip" {
  count      = var.target_level == "org" ? 1 : 0
  org_id     = var.target_id
  constraint = "constraints/compute.vmExternalIpAccess"

  list_policy {
    deny {
      all = true
    }
  }
}


resource "google_organization_policy" "org_disable_default_network" {
  count      = var.target_level == "org" ? 1 : 0
  org_id     = var.target_id
  constraint = "constraints/compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = true
  }
}


resource "google_project_organization_policy" "project_policy_list_exclude_projects" {
  for_each = toset(var.exclude_projects_block_vm_external_ip)

  project    = each.value
  constraint = "constraints/compute.vmExternalIpAccess"

  restore_policy {
    default = true
  }
}

resource "google_project_organization_policy" "project_policy_list_exclude_projects_1" {
  for_each = toset(var.exclude_projects_skip_default_network_creation)

  project    = each.value
  constraint = "constraints/compute.skipDefaultNetworkCreation"

  restore_policy {
    default = true
  }
}