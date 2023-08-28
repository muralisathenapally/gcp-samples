variable "name" {
  description = "Name of the resource policy to create"
  type        = string
}

variable "project" {
  description = "The project ID where the resources will be created"
  type        = string
}

variable "region" {
  description = "Region where resource policy resides"
  type        = string
}

variable "snapshot_retention_policy" {
  description = "The retention policy to be applied to the schedule policy"
  type = object(
    {
      max_retention_days    = number
      on_source_disk_delete = string
    }
  )
}

variable "snapshot_schedule" {
  description = "The scheduled to be used by the snapshot policy"
  type = object(
    {
      daily_schedule = object(
        {
          days_in_cycle = number
          start_time    = string
        }
      )
      hourly_schedule = object(
        {
          hours_in_cycle = number
          start_time     = string
        }
      )
      weekly_schedule = object(
        {
          day_of_weeks = set(object(
            {
              day        = string
              start_time = string
            }
          ))
        }
      )
    }
  )
  default = {
    daily_schedule = {
      days_in_cycle = 1
      start_time    = "08:00"
    }
    hourly_schedule = null
    weekly_schedule = null
  }
}
variable "snapshot_properties" {
  description = "The properties of the schedule policy"
  type = object(
    {
      guest_flush       = bool
      labels            = map(string)
      storage_locations = list(string)
    }
  )
  default = null
}

variable "disks" {
  description = "name of the disk"
  default     = []
}
variable "disks_zone" {
  description = "zone of the disk"
  default     = ""

}