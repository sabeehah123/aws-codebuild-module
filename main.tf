resource "aws_codebuild_project" "project" {
  name           = var.project_name
  description    = var.description
  service_role   = aws_iam_role.service_role.arn

  artifacts {
    type = var.artifact_type
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.environment_image
    type                        = var.environment_type
    image_pull_credentials_type = var.image_pull_credentials_type
    privileged_mode             = var.privileged_mode
  
    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
    } 
    }
  }

  logs_config {
      cloudwatch_logs { 
          group_name  = var.log_group_name
          stream_name = var.stream_name
          }
  }

  source {
    type            = var.source_type
    location        = var.source_location
    git_clone_depth = var.git_clone_depth 
  }

  source_version = var.source_version

  tags = local.common_tags
  
}

resource "aws_iam_role" "service_role" {
  name               = var.service_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_codebuild.json
}

data "aws_iam_policy_document" "assume_role_policy_codebuild" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild-test-project-service-role-policy"
  role = aws_iam_role.service_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow",
            Resource = [
                "arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:/aws/codebuild/${var.project_name}",
                "arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:/aws/codebuild/${var.project_name}:*"
            ],
            Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
            ]
        },
        {
            Effect = "Allow",
            Resource = [
                "arn:aws:s3:::codepipeline-${var.region}-*"
            ],
            Action = [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            Effect = "Allow",
            Action = [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "codebuild:BatchPutCodeCoverages"
            ],
            Resource = [
                "arn:aws:codebuild:${var.region}:${var.aws_account_id}:report-group/${var.project_name}-*"
            ],
        },
        {
            Effect = "Allow",
            Resource = [
                "arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:${var.log_group_name}",
                "arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:${var.log_group_name}:*"
            ],
            Action = [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            Effect = "Allow",
            Action = [
                "ecr:*",
                "cloudtrail:LookupEvents"
            ],
            Resource = "*"
        },
        {
            Effect = "Allow",
            Action = [
                "iam:CreateServiceLinkedRole"
            ],
            Resource = "*",
                Condition = {
                    StringEquals = {
                        "iam:AWSServiceName": [
                            "replication.ecr.amazonaws.com"
                        ]
                    }
                }
        }
    ]
  })

}
