resource "aws_s3_bucket" "default" {
  count = var.create_bucket ? 1 : 0

  bucket = var.s3_bucket
}

resource "aws_s3_bucket_acl" "default" {
  count = var.create_bucket ? 1 : 0
  bucket = join("", aws_s3_bucket.default.*.id)
  acl = var.acl
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  count = var.create_bucket ? 1 : 0
  bucket = join("", aws_s3_bucket.default.*.id)
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = lookup(var.server_side_encryption_configuration, "sse_algorithm", "AES256")
      kms_master_key_id = lookup(var.server_side_encryption_configuration, "kms_master_key_id", null)
    }
  }
}

resource "aws_s3_bucket_public_access_block" "default" {

  count = var.create_bucket ? 1 : 0

  bucket                  = var.s3_bucket
  block_public_acls       = lookup(var.public_access_block, "block_public_acls", null)
  block_public_policy     = lookup(var.public_access_block, "block_public_policy", null)
  ignore_public_acls      = lookup(var.public_access_block, "ignore_public_acls", null)
  restrict_public_buckets = lookup(var.public_access_block, "restrict_public_buckets", null)
}

resource "aws_s3_object" "default" {
  count = var.create_bucket ? 1 : 0

  bucket = join("", aws_s3_bucket.default.*.id)
  key    = var.s3_key
  source = var.file_path

}
