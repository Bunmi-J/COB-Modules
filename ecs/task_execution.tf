resource "aws_ecs_task_definition" "task_def" {
      family = "service" 
      network_mode             = "awsvpc"
      requires_compatibilities = ["EC2"]

      execution_role_arn = var.execution_role_arn
      task_role_arn      = var.task_role_arn
      container_definitions = jsonencode([
        {
          name      = "${var.task1}"
          image     = "${var.service_task1}" #service-first"
          cpu       = 10
          memory    = 512
          essential = true
          portMappings = [
            {
                containerPort = 80
                hostPort      = 80
            }
           ]
        },
        {
                  name      = "${var.task2}" #second"
                  image     = "${var.service_task2}" #service-second"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
    }
  ])

# volume {
#    name      = "${var.service_storage_name}" 
#   host_path = "/ecs/${var.service_storage_name}"
#  }

# placement_constraints {
#    type       = "memberOf"
#   expression = "attribute:ecs.availability-zone in [eu-north-1a, eu-north-1b]"
# }
}