resource "azuredevops_variable_group" "variablegroup" {
  project_id   = var.Azure_ProjectID
  name         = "Test Variable Group"
  description  = "Test Variable Group Description"
  allow_access = true

  variable {
    name = "solution"
    value = "**/*.sln"
            }
  }

resource "azuredevops_git_repository" "Terraform-Test-Repo" {
  project_id = var.Azure_ProjectID
  name       = var.Repo_Name
  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = var.GIT_Import_URL
                  }
}

resource "azuredevops_build_definition" "Terraform-build" {
  project_id = var.Azure_ProjectID
  name = var.Pipeline_Name
  agent_pool_name = "Azure Pipelines"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type = "TfsGit"
    repo_id = azuredevops_git_repository.Terraform-Test-Repo.id
    branch_name = azuredevops_git_repository.Terraform-Test-Repo.default_branch
    yml_path = "azure-pipelines.yml"
  }
  variable_groups = [azuredevops_variable_group.variablegroup.id]
}
