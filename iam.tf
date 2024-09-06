#IAM role to allow EC2 instances to write logs to the Logs bucket
resource "aws_iam_role" "ec2_logs_role" {
  name = "ec2-logs-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

#Policy that grants write permissions to the Logs S3 bucket
resource "aws_iam_policy" "logs_policy" {
  name = "ec2-logs-policy"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["s3:PutObject", "s3:PutObjectAcl", 
          "s3:ListBucket", "s3:GetObject"],
      Effect   = "Allow",
      Resource = "arn:aws:s3:::logs-coalfire-demo213-bucket/*"
    }]
  })
}

#Attached the policy to the EC2 role
resource "aws_iam_role_policy_attachment" "logs_policy_attach" {
  role       = aws_iam_role.ec2_logs_role.name
  policy_arn = aws_iam_policy.logs_policy.arn
}

resource "aws_iam_role_policy_attachment" "logs_policy_attach_s3" {
  role       = aws_iam_role.ec2_logs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" 
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  role = aws_iam_role.ec2_logs_role.name
}


resource "aws_iam_role" "alb_logs_role" {
  name = "alb-logs-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "elasticloadbalancing.amazonaws.com"
      }
    }]
  })
}

#Attached the policy to the ALB role
resource "aws_iam_role_policy_attachment" "alb_logs_policy_attach" {
  role       = aws_iam_role.alb_logs_role.name
  policy_arn = aws_iam_policy.logs_policy.arn
}

resource "aws_iam_role_policy_attachment" "alb_logs_policy_attach_s3" {
  role       = aws_iam_role.alb_logs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" 
}