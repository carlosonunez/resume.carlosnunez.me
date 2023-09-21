resource "random_string" "bucket" {
  length  = 8
  upper   = false
  special = false
}

resource "aws_s3_bucket" "resume" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "resume_bucket" {
  bucket = aws_s3_bucket.resume.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "resume_bucket" {
  bucket = aws_s3_bucket.resume.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "resume" {
  depends_on = [
    aws_s3_bucket_public_access_block.resume_bucket,
    aws_s3_bucket_ownership_controls.resume_bucket
  ]
  for_each     = local.resume_bucket_keys
  bucket       = aws_s3_bucket.resume.id
  key          = each.value
  source       = "./output/${each.key}"
  etag         = filemd5("./output/${each.key}")
  acl          = "public-read"
  content_type = endswith(each.key, "html") ? "text/html" : "application/pdf"
}
