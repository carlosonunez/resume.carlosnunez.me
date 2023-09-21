locals {
  bucket_name = "${random_string.bucket.result}-${var.resume_record_name}-resume-bucket"
  resume_fqdn = "${var.resume_record_name}.${data.aws_route53_zone.zone.name}"
  resume_bucket_keys = {
    "${var.resume_file_name}.pdf"  = "latest.pdf"
    "${var.resume_file_name}.html" = "index.html"
    "favicon.ico"                  = "favicon.ico"
    "logo.png"                     = "logo.png"
  }
  cloudfront_origin_id = "cf-origin-${var.resume_record_name}"
}
