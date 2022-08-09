custom_iam_role = {
  "project-adminrole" = {
    role_id      = "adminrole"
    title        = "Admin Role"
    permissions  = []
    description  = "project admin role"
    target_id    = "vm-test-nessus" // possible values are: project id or org id
    target_level = "project"        // possible values are: project or org
  }
}