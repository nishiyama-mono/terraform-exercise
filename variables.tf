
variable "access_key" {}
variable "secret_key" {}

variable "name" {
    default = "exercise"
}

variable "region" {
    default = "ap-northeast-1"
}

variable "cidr" {
    type = "map"

    default = {
        vpc = "10.0.0.0/8"
        any = "0.0.0.0/0"
    }
}

variable "env" {
    type = "map"

    default = {
        prd = 0
        stg = 1
    }
}

variable "newbit" {
    default = "8"
}

variable "application_segment" {
    default = "20"
}

variable "private_offset" {
    default = "100"
}

