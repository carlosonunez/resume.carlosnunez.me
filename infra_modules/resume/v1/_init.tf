terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws",
      configuration_aliases = [
        aws.acm,
      ]
    }
  }
}

data "aws_route53_zone" "zone" {
  name = "${var.zone_name}."
}

