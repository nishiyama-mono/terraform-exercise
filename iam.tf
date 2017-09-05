
data "aws_iam_role" "opsworks_service" {
    name = "aws-opsworks-service-role"
}

resource "aws_iam_instance_profile" "opsworks_instance" {
    role = "${aws_iam_role.opsworks_instance.name}"
    name_prefix = "${aws_iam_role.opsworks_instance.name}--"
}


## IAM Role

resource "aws_iam_role" "opsworks_service" {
    name = "${var.name}-${terraform.env}-opsworks-service"
    path = "/opsworks/"

    description = "OpsWorks Service policy allowed to read cookbook archive in S3."

    assume_role_policy = "${data.aws_iam_policy_document.opsworks.json}"
}

resource "aws_iam_role" "opsworks_instance" {
    name = "${var.name}-${terraform.env}-opsworks-instance"
    path = "/opsworks/"

    description = "OpsWorks EC2 instance policy allowed to read cookbook archive in S3."

    assume_role_policy = "${data.aws_iam_policy_document.ec2.json}"
}

## IAM Policy

### default
data "aws_iam_policy_document" "opsworks_service" {
    statement {
        effect = "Allow"

        actions = [
            "ec2:*",
            "iam:PassRole",
            "cloudwatch:GetMetricStatistics",
            "cloudwatch:DescribeAlarms",
            "ecs:*",
            "elasticloadbalancing:*",
            "rds:*",
        ]

        resources = ["*"]
    }
}

### Assume Role Policy

data "aws_iam_policy_document" "ec2" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]

        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "opsworks" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]

        principals {
            type = "Service"
            identifiers = ["opsworks.amazonaws.com"]
        }
    }
}

