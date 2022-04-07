locals {
  common_tags = tomap({
    Region      = var.region
    Environment = var.environment
    Terraform   = "true"
    ManagedBy   = var.managedby
  })

}

