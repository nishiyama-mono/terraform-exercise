
# Availability Zone
data "aws_availability_zones" "az" {}

## VPC
resource "aws_vpc" "main" {
    cidr_block = "${cidrsubnet(var.cidr["vpc"], var.newbit, var.application_segment)}"

    tags {
        Name = "${var.name}-${terraform.env}"
        Environment = "${terraform.env}"
    }
}

