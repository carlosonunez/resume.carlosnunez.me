resource "aws_cloudfront_origin_access_identity" "default" {}

resource "aws_cloudfront_distribution" "resume" {
  origin {
    domain_name = aws_s3_bucket.resume.bucket_regional_domain_name
    origin_id   = local.cloudfront_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [local.resume_fqdn]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.cloudfront_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    domain-name = var.resume_record_name
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }
}
