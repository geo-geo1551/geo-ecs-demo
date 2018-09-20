data "aws_ecs_task_definition" "helloworld" {
  task_definition = "${aws_ecs_task_definition.helloworld.family}"
}

resource "aws_ecs_task_definition" "helloworld" {
    family                = "hello_world"
    container_definitions = "${file("hello-world-task-def.json")}"
    

}
