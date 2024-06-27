## Project level example##
#target_level = "project"
#target_ids = ["your-project-id"]
#exclude_projects_block_vm_external_ip = []
#exclude_projects_skip_default_network_creation = []

## Org level example##
#target_level = "org"
#target_ids = ["123456789"]
#exclude_projects_block_vm_external_ip = []
#exclude_projects_skip_default_network_creation = []

## Folder level example##
#target_level = "folder"
#target_ids = ["folders/123456789"]
#exclude_projects_block_vm_external_ip = []
#exclude_projects_skip_default_network_creation = []


target_level                                   = "org"
target_ids                                     = ["123456789"]
exclude_projects_block_vm_external_ip          = []
exclude_projects_skip_default_network_creation = []

### Allow specified VMs to have public ip ###
allowed_external_ip_vms = {
  "psyched-circuit-405312" = {   ## project that has the vm to allow public ip
    vm_list = ["projects/psyched-circuit-405312/zones/us-east4-c/instances/test-intance"] ## list of vm's to allow public ip
  },
  "united-lane-354904" = { ## project that has the vm to allow public ip
    vm_list = ["projects/united-lane-354904/zones/us-east4-c/instances/my-vm"] ## list of vm's to allow public ip
  }
}