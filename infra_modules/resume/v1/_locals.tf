locals {
  bucket_name = "${random_string.bucket.result}-${var.resume_record_name}-resume-bucket"
  resume_fqdn = "${var.resume_record_name}.${data.aws_route53_zone.zone.name}"
  cloudfront_origin_id = "cf-origin-${var.resume_record_name}"
  mime_types = {
    htm   = "text/html"
    html  = "text/html"
    css   = "text/css"
    ttf   = "font/ttf"
    js    = "application/javascript"
    map   = "application/javascript"
    json  = "application/json"
    xml = "application/xml"
    pdf = "application/pdf"
  }
}
