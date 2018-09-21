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


# Scaling alarms

resource "aws_cloudwatch_metric_alarm" "test-ecs-service_high_cpu" {
  alarm_name          = "test-ecs-service_high_cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions {
    ClusterName = "${var.ecs_cluster}"
	ServiceName = "${aws_ecs_service.test-ecs-service.name}"
  }

  alarm_description = "Scale up if CPUUtilization is above N% for N duration"
  alarm_actions     = ["${aws_appautoscaling_policy.up.arn}"]

  depends_on = [
    "aws_appautoscaling_policy.up",
  ]
}

resource "aws_cloudwatch_metric_alarm" "test-ecs-service_low_cpu" {
  alarm_name          = "test-ecs-service_low_cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "40"

  dimensions {
    ClusterName = "${var.ecs_cluster}"
	ServiceName = "${aws_ecs_service.test-ecs-service.name}"
  }

  alarm_description = "Scale down if CPUUtilization is less N% for N duration"
  alarm_actions     = ["${aws_appautoscaling_policy.down.arn}"]

   depends_on = [
    "aws_appautoscaling_policy.down",
  ]

}

#
# Application AutoScaling resources
#
resource "aws_appautoscaling_target" "main" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster}/${aws_ecs_service.test-ecs-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = "1"
  max_capacity       = "10"

  depends_on = [
    "aws_ecs_service.test-ecs-service",
  ]
}

resource "aws_appautoscaling_policy" "up" {
  name               = "appScalingPolic${var.ecs_cluster}/${aws_ecs_service.test-ecs-service.name}ScaleUp"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster}/${aws_ecs_service.test-ecs-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "20"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [
    "aws_appautoscaling_target.main",
  ]
}

resource "aws_appautoscaling_policy" "down" {
  name               = "appScalingPolicy${var.ecs_cluster}/${aws_ecs_service.test-ecs-service.name}ScaleDown"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster}/${aws_ecs_service.test-ecs-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "20"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [
    "aws_appautoscaling_target.main",
  ]
}
