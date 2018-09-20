

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${aws_ecs_cluster.test-ecs-cluster.name}-dashboard"

  dashboard_body = <<EOF
  {
      "widgets": [
          {
              "type": "metric",
              "x": 0,
              "y": 0,
              "width": 6,
              "height": 6,
              "properties": {
                  "view": "timeSeries",
                  "stacked": false,
                  "metrics": [
                      [ "AWS/ECS", "MemoryUtilization", "ClusterName", "${aws_ecs_cluster.test-ecs-cluster.name}" ]
                  ],
                  "region": "eu-west-1",
                  "title": "ECS Memory Utilization"
              }
          },
          {
              "type": "metric",
              "x": 6,
              "y": 0,
              "width": 6,
              "height": 6,
              "properties": {
                  "view": "timeSeries",
                  "stacked": false,
                  "metrics": [
                      [ "AWS/ECS", "CPUUtilization", "ClusterName", "${aws_ecs_cluster.test-ecs-cluster.name}" ]
                  ],
                  "region": "eu-west-1",
                  "title": "ECS CPU Utilization"
              }
          },
          {
              "type": "metric",
              "x": 0,
              "y": 6,
              "width": 6,
              "height": 6,
              "properties": {
                  "view": "timeSeries",
                  "stacked": false,
                  "metrics": [
                      [ "AWS/ECS", "MemoryReservation", "ClusterName", "${aws_ecs_cluster.test-ecs-cluster.name}" ]
                  ],
                  "region": "eu-west-1",
                  "title": "ECS Memory Reservation"
              }
          },
          {
              "type": "metric",
              "x": 6,
              "y": 6,
              "width": 6,
              "height": 6,
              "properties": {
                  "view": "timeSeries",
                  "stacked": false,
                  "metrics": [
                      [ "AWS/ECS", "CPUReservation", "ClusterName", "${aws_ecs_cluster.test-ecs-cluster.name}" ]
                  ],
                  "region": "eu-west-1",
                  "title": "ECS CPU Reservation"
              }
          },
          {
              "type": "metric",
              "x": 12,
              "y": 0,
              "width": 6,
              "height": 6,
              "properties": {
                  "view": "timeSeries",
                  "stacked": false,
                  "metrics": [
                      [ "AWS/ECS", "CPUReservation", "ClusterName", "func-cluster", { "visible": false } ],
                      [ "AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", "${aws_autoscaling_group.ecs-autoscaling-group.name}" ]
                  ],
                  "region": "eu-west-1",
                  "title": "ECS instances running"
              }
          }
      ]
  }
 EOF
}
