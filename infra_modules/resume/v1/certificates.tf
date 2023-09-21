resource "aws_acm_certificate" "cert" {
  provider          = aws.acm
  domain_name       = local.resume_fqdn
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    domain-name = local.resume_fqdn
  }
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.acm
  name     = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type     = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  zone_id  = data.aws_route53_zone.zone.id
  records  = ["${tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value}"]
  ttl      = 60
}


resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}
