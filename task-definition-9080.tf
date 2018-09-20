#data "aws_ecs_task_definition" "helloworld9080" {
#  task_definition = "${aws_ecs_task_definition.helloworld9080.family}"
#}

resource "aws_ecs_task_definition" "helloworld9080" {
    family                = "hello_world-9080"
    container_definitions = "${file("hello-world-9080-task-def.json")}"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    cpu                      = 256
    memory                   = 512

    #task_role_arn            = "${aws_iam_role.github-role.arn}"
    #execution_role_arn       = "arn:aws:iam::aws:policy/service-role/ecsTaskExecutionRole"
    
    execution_role_arn       = "${aws_iam_role.ecs_execution_role.arn}"
    task_role_arn            = "${aws_iam_role.ecs_execution_role.arn}"

}
