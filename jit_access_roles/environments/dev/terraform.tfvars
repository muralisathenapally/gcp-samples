target_level = "project"
target_id    = "project-id"

members = [
  "user:user1@gmail.com",
  "user:user2@gmail.com"
]

roles = [
  "roles/bigquery.jobUser",
  "roles/storage.admin"
]

condition = {
  title       = "JIT Access Constraint"
  description = "Grants access based on JIT constraint"
  expression  = "has({}.jitAccessConstraint)"
}