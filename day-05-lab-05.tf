resource "aws_ecs_cluster" "cb" {
  name = "cb_terraform_cluster"

  tags = {
    Name    = "cb_terraform_ecs_cluster"
    Course  = "CloudBasics"
    Purpose = "Day 5 Lab 5"
  }
}

resource "aws_ecs_service" "cb" {
  name = "cb_terraform_ecs_service"
  cluster = aws_ecs_cluster.cb.id
}

resource "aws_ecs_task_definition" "cb" {
  container_definitions = ""
  family = "cb_tf_fargate"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
}