terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}


provider "aws" {
  alias  = "acm-us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

locals {
  config = yamldecode(file("./config.yaml"))
  zone = local.config.dns.zone
  resume_personas = {for resume in local.config.resume.personas : resume.name => tomap({
      record_name = "${try(resume.record, resume.name)}.${local.config.dns.root}",
      file_name = resume.yaml
  })}
  resumes = merge(local.resume_personas, { default = {
    record_name = "resume",
    file_name = local.resume_personas[local.config.resume.default_persona].file_name
  }})
}

module "resumes" {
  providers = {
    aws.acm = aws.acm-us-east-1
  }
  for_each           = local.resumes
  source             = "./infra_modules/resume/v1"
  zone_name          = local.zone
  resume_record_name = each.value.record_name
  resume_file_name   = each.value.file_name
}
