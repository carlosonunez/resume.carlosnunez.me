resource "aws_route53_record" "resume" {
  depends_on = [aws_s3_object.resume]
  zone_id    = data.aws_route53_zone.zone.id
  name       = var.resume_record_name
  type       = "A"
  alias {
    name                   = aws_cloudfront_distribution.resume.domain_name
    zone_id                = aws_cloudfront_distribution.resume.hosted_zone_id
    evaluate_target_health = true
  }
}
