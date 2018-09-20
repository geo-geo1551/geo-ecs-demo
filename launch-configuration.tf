data "template_file" "main" {
  template = "${file("${path.module}/user_data/cloud-config.yml")}"

  vars {
    stack_name       = "${var.ecs_autoscaling_group_name}"
    region           = "${var.region}"
    log_group_name   = "${aws_ecs_cluster.test-ecs-cluster.name}-instances"
    ecs_cluster_name = "${var.ecs_cluster}"
    ecs_log_level    = "${var.ecs_log_level}"
  }
}

resource "aws_launch_configuration" "ecs-launch-configuration" {
    name_prefix                 = "ecs-launch-configuration"
    image_id                    = "ami-0dbcd2533bc72c3f6"
    instance_type               = "t3.micro"
    iam_instance_profile        = "${aws_iam_instance_profile.ecs-instance-profile.id}"

    root_block_device {
      volume_type = "standard"
      volume_size = 100
      delete_on_termination = true
    }

    lifecycle {
      create_before_destroy = true
    }

    security_groups             = ["${aws_security_group.test_public_sg.id}","${aws_security_group.test_public_sg_2.id}"]
    associate_public_ip_address = "true"
    key_name                    = "${var.ecs_key_pair_name}"
    user_data                   = "${data.template_file.main.rendered}"
    /*
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
                                  EOF*/
                                  
}
