module "firewall_policy" {
  source                            = "../../modules"
  firewall_policy_parent            = "organizations/12345"
  ports_to_block                    = [22, 80, 3389]
  attachment_target                 = "folder/12345"
  firewall_policy_association_nanme = "associate_with_folder"
}