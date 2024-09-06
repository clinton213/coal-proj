resource "aws_s3_bucket" "logs2131_bucket" {
  bucket = "logs-coalfire-demo213-bucket"

  tags = {
    Name = "logs-coalfire-demo213-bucket"
  }
}

resource "aws_s3_bucket" "media2131_bucket" {
  bucket = "media-coalfire-demo213-bucket"

  tags = {
    Name = "media-coalfire-demo213-bucket"
  }
}
