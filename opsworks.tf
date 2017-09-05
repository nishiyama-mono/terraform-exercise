# OpsWorks

## Stack

resource "aws_opsworks_stack" "main" {
    name = "${var.name}-${terraform.env}"
    region = "${var.region}"
    vpc_id = "${aws_vpc.main.id}"

    service_role_arn = "${data.aws_iam_role.opsworks_service.arn}"
    default_instance_profile_arn = "${aws_iam_instance_profile.opsworks_instance.arn}"

    default_subnet_id = "${aws_subnet.private.0.id}"
    default_os = "Ubuntu 16.04 LTS"
    default_root_device_type = "ebs"

    agent_version = "LATEST"

    configuration_manager_version = 12
}

## Layer

resource "aws_opsworks_custom_layer" "web" {
    stack_id = "${aws_opsworks_stack.main.id}"
    name = "WEB"
    short_name = "web"

    # disable auto healing
    auto_healing = false

    # network

    # security
    custom_security_group_ids = [
        "${data.aws_security_group.default.id}"
    ]

    custom_setup_recipes = []
    custom_configure_recipes = []
    custom_deploy_recipes = []
    custom_undeploy_recipes = []
    custom_shutdown_recipes = []

}

## Instance

resource "aws_opsworks_instance" "web" {
    stack_id = "${aws_opsworks_stack.main.id}"
    layer_ids = ["${aws_opsworks_custom_layer.web.id}"]
    instance_type = "${var.opsworks_instance_type["web.${terraform.env}"]}"

    state = "running"

    count = "${var.opsworks_instance_count["web.${terraform.env}"]}"
    hostname = "${aws_opsworks_custom_layer.web.short_name}-${count.index}"
    subnet_id = "${aws_subnet.private.*.id[count.index % aws_subnet.private.count]}"
}

