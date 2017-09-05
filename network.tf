
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

## Subnets

### Public Subnet
resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.main.id}"

    count = "${length(data.aws_availability_zones.az.names)}"

    cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, var.newbit, count.index)}"
    availability_zone = "${data.aws_availability_zones.az.names[count.index]}"

    tags {
        Name = "${var.name}-${terraform.env}-public-${count.index}"
        Environment = "${terraform.env}"
    }
}

### Private Subnet
resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.main.id}"

    count = "${length(data.aws_availability_zones.az.names)}"

    cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, var.newbit, count.index + var.private_offset)}"
    availability_zone = "${data.aws_availability_zones.az.names[count.index]}"

    tags {
        Name = "${var.name}-${terraform.env}-public-${count.index}"
        Environment = "${terraform.env}"
    }
}

## EIP
resource "aws_eip" "nat_gateway" {
    count = "${length(data.aws_availability_zones.az.names)}"
}

## Gateways

### Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "${var.name}-${terraform.env}"
        Environment = "${terraform.env}"
    }
}

