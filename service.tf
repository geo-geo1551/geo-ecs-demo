resource "aws_ecs_service" "test-ecs-service" {
  	name            = "test-ecs-service"
  	iam_role        = "${aws_iam_role.ecs-service-role.name}"
  	cluster         = "${aws_ecs_cluster.test-ecs-cluster.id}"
  	task_definition = "${aws_ecs_task_definition.helloworld.family}:${max("${aws_ecs_task_definition.helloworld.revision}", "${data.aws_ecs_task_definition.helloworld.revision}")}"
  	desired_count   = "${var.desired_capacity_ecsec2}"
	health_check_grace_period_seconds = 10

  	load_balancer {
    	target_group_arn  = "${aws_alb_target_group.ecs-target-group.arn}"
    	container_port    = 80
    	container_name    = "hello-world"
	}

	depends_on = ["aws_iam_role.ecs-service-role","aws_alb_listener.alb-listener"]
}
