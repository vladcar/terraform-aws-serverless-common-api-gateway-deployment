
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = var.rest_api_id
  stage_name  = var.stage

  # hack to force redeployment every time this hash changes
  triggers = {
    redeployment = sha1(join(",", var.required_resources))
  }

  # might be changed to true in some very specific cases
  lifecycle {
    create_before_destroy = false
  }
}
