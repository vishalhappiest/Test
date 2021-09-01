resource "azuredevops_build_definition" "Terraform-Build" {
  project_id = azuredevops_project.tf-example.id
  name = "Build Definition for forked-repo"
  agent_pool_name = "Azure Pipelines"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type = "TfsGit"
    repo_id = data.azuredevops_git_repositories.forked-repo.repositories[0].id
    branch_name = data.azuredevops_git_repositories.forked-repo.repositories[0].default_branch
    yml_path = "azure-pipelines.yml"
  }

  variable_groups = [azuredevops_variable_group.variablegroup.id]

  variable {
    name = "solution"
    value = "**/*.sln"
  }
}
