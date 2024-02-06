module "constraints" {
  source = "../../module/"
  for_each = toset(var.target_ids)
  target_id = each.value
  target_level = var.target_level
}