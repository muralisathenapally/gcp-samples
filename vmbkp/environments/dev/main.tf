module "disk_snapshots" {
  for_each   = var.instance_details
  source     = "../../modules/"
  name       = "${each.key}-policy"
  project    = each.value.project
  region     = each.value.region
  disks      = each.value.disks
  disks_zone = each.value.disks_zone

  snapshot_retention_policy = each.value.snapshot_retention_policy
  snapshot_schedule         = each.value.snapshot_schedule
  snapshot_properties = {
    guest_flush       = true
    storage_locations = [each.value.region]
    labels            = null
  }
}