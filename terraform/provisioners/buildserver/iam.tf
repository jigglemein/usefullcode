
resource "aws_iam_instance_profile" "build_service_profile" {
  name = "build_server_profile"
  role = "${aws_iam_role.build_server_role.name}"
}

resource "aws_iam_role" "build_server_role" {
  name = "build_server_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "build_server_policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*",
        "s3:*",
        "route53:*",
        "iam:PassRole",
        "iam:ListInstanceProfiles",
        "iam:GetRole",
        "autoscaling:*",
        "elasticloadbalancing:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "build_server_policy_role_attach" {
    role       = "${aws_iam_role.build_server_role.name}"
    policy_arn = "${aws_iam_policy.build_server_policy.arn}"
}
