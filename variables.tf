variable region {
  type = string 
  default = "eu-west-1"
}

variable environment {
  type = string 
}

variable managedby {
  type = string 
  default = "Rackspace"
}

variable aws_account_id {
  type = string
}

variable project_name {
  type = string 
  description = "Name of codebuild project"
}

variable description {
  type = string 
  description = "Description of project"
}

variable artifact_type {
  type = string 
  description = "Build output artifact's type"
  default = "NO_ARTIFACTS"
}

variable compute_type {
  type = string
  description = "Information about the compute resources the build project will use"
  default = "BUILD_GENERAL1_SMALL"
}

variable environment_image {
  type = string
  description = "Docker image to use for this build project"
  default = "aws/codebuild/standard:5.0"
}

variable environment_type {
  type = string
  description = "Type of build environment to use for related builds"
  default = "LINUX_CONTAINER"
}

variable image_pull_credentials_type {
  type = string
  description = "Type of credentials AWS CodeBuild uses to pull images in your build. Use either CODEBUILD or SERVICE_ROLE."
  default = "CODEBUILD"
}

variable privileged_mode {
  type = bool
  description = "Whether to enable running the Docker daemon inside a Docker container"
  default = true 
}

variable "environment_variables" {
  type = list(object(
    {
      name  = string
      value = string
    }))
  description = "Environment variables to feed into buildspec.yaml file"
}

variable log_group_name {
  type = string 
  description = "Group name of the logs in CloudWatch Logs"
}

variable stream_name {
  type = string 
  description = "Stream name of the logs in CloudWatch Logs"
}

variable source_type {
  type = string 
  description = "Type of repository that contains the source code to be built"
  default = "GITHUB"
}

variable source_location {
  type = string 
  description = " Location of the source code from git or s3"
}

variable git_clone_depth {
  type = number 
  description = "Truncate git history to this many commits"
  default = 1
}

variable source_version {
  type = string 
  description = " The source version for the corresponding source identifier e.g branch name or commit ID if using git"
}

variable service_role_name {
  type = string 
  description = "Service role name for codebuild project"
  default = "codebuild-project-service-role"
}

