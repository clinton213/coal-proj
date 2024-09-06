resource "aws_iam_role" "Logs2131_s3_access_for_ec2" {
  name = "Logs2131_s3_access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "Logs2131_s3_access" {
  name = "s3_access_limited"
  role = aws_iam_role.Logs2131_s3_access_for_ec2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListAllMyBuckets",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::logs-coalfire-demo213-bucket",
          "arn:aws:s3:::logs-coalfire-demo213-bucket/*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "Logs2131_instance_profile" {
  name = "Logs2131-instance-profile"
  role = aws_iam_role.Logs2131_s3_access_for_ec2.name
}
