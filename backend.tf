terraform {
  cloud {
    organization = "Modul-306"

    workspaces {
      name = "Modul-306-infra"
    }
  }
}

# creating a team in TFE
resource "tfe_team" "developers" {
  name         = "Module-306-infra"
  organization = "Module-306"
}