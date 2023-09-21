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
  zone = "carlosnunez.me"
  resumes = {
    default = {
      record_name = "resume"
      file_name   = "consulting"
    }
    dev = {
      record_name = "eng.resume"
      file_name   = "eng"
    }
    consulting = {
      record_name = "consulting.resume"
      file_name   = "consulting"
    }
  }
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
