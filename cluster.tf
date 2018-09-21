resource "aws_ecs_cluster" "test-ecs-cluster" {
    name = "${var.ecs_cluster}"
}


resource "random_integer" "alarm_random_postfix" {
  min = 11111
  max = 99999
}

resource "aws_cloudwatch_metric_alarm" "UtilizationDataStorageAlarm" {
  alarm_name          = "ecs-volume-usage-${random_integer.alarm_random_postfix.result}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "UtilizationDataStorage"
  namespace           = "System/Linux"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"
  alarm_description   = "Alarm when docker volume usage reach 50 percent"

  dimensions {
    AutoScalingGroupName = "${var.ecs_autoscaling_group_name}"
  }
}
resource "aws_cloudwatch_metric_alarm" "container_instance_high_memory" {
  alarm_name          = "alarm-ecs-memory-reservation-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    ClusterName = "${var.ecs_cluster}"
  }

  alarm_description = "Scale up if MemoryReservation is above N% for N duration"
  alarm_actions     = ["${aws_autoscaling_policy.container_instance_scale_up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "container_instance_low_memory" {
  alarm_name          = "alarm-ecs-memory-reservation-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "40"

  dimensions {
    ClusterName = "${var.ecs_cluster}"
  }

  alarm_description = "Scale down if MemoryReservation is less N% for N duration"
  alarm_actions     = ["${aws_autoscaling_policy.container_instance_scale_down.arn}"]

  depends_on = ["aws_cloudwatch_metric_alarm.container_instance_high_memory"]
}

resource "aws_autoscaling_policy" "container_instance_scale_up" {
  name                   = "asgScalingPolicyMemoryReservationClusterScaleUp"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "300"
  autoscaling_group_name = "${var.ecs_autoscaling_group_name}"
}

resource "aws_autoscaling_policy" "container_instance_scale_down" {
  name                   = "asgScalingPolicyMemoryReservationClusterScaleDown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "300"
  autoscaling_group_name = "${var.ecs_autoscaling_group_name}"
}
