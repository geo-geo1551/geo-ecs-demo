/*
Configuration modified for Fargate
*/

resource "aws_ecs_service" "test-ecs-service-9080" {
  	name            = "test-ecs-service-9080"
  	#iam_role        = "${aws_iam_role.ecs-service-role.name}"
  	cluster         = "${aws_ecs_cluster.test-ecs-cluster.id}"
  	#task_definition = "${aws_ecs_task_definition.helloworld9080.family}:${max("${aws_ecs_task_definition.helloworld9080.revision}", "${data.aws_ecs_task_definition.helloworld9080.revision}")}"
  	task_definition = "${aws_ecs_task_definition.helloworld9080.arn}"
	desired_count   = "${var.desired_capacity_fargate}"
	health_check_grace_period_seconds = 10
	launch_type     = "FARGATE"

  	
	load_balancer {
    	target_group_arn  = "${aws_alb_target_group.ecs-target-group-9080.arn}"
    	container_port    = 9080
    	container_name    = "hello-world-9080"
	}

	network_configuration {
    	security_groups = ["${aws_security_group.test_public_sg.id}","${aws_security_group.test_public_sg_2.id}"]
    	subnets         = ["${aws_subnet.test_public_sn_01.id}","${aws_subnet.test_public_sn_02.id}"]
		assign_public_ip = true
  	}

	depends_on = ["aws_iam_role.ecs-service-role","aws_alb_listener.alb-listener-9080"]
}
