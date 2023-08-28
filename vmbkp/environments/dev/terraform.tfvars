instance_details = {
  "instance-name" = {
    project    = ""
    region     = "us-central1"
    disks      = ["disk2", "disk1"]
    disks_zone = "us-central1-c"
    snapshot_retention_policy = {
      max_retention_days    = 10
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_schedule = {
      daily_schedule = {
        days_in_cycle = 1
        start_time    = "08:00" #specify in UTC"
      }
      hourly_schedule = null
      weekly_schedule = null
    }
  }
}
