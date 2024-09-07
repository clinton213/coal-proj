resource "aws_s3_bucket" "logs2131_bucket" {
  bucket = "logs-coalfire-demo213-bucket"

  tags = {
    Name = "logs-coalfire-demo213-bucket"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "coalfire_logs_lifecycle" {
  bucket = aws_s3_bucket.logs2131_bucket.bucket

  rule {
    id     = "active-rule"
    status = "Enabled"

    filter {
      prefix = "active/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  rule {
    id     = "inactive-rule"
    status = "Enabled"

    filter {
      prefix = "inactive/"
    }

    expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket" "media2131_bucket" {
  bucket = "media-coalfire-demo213-bucket"

  tags = {
    Name = "media-coalfire-demo213-bucket"
  }
}
# Lifecycle rule for media bucket - move to Glacier after 90 days
resource "aws_s3_bucket_lifecycle_configuration" "coalfire_media_lifecycle" {
  bucket = aws_s3_bucket.media2131_bucket.id

  rule {
    id     = "memes-rule"
    status = "Enabled"

    filter {
      prefix = "memes/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  rule {
    id     = "archive-rule"
    status = "Enabled"

    filter {
      prefix = "archive/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}
