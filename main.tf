
resource "aws_api_gateway_stage" "stage" {
  stage_name    = var.stage
  rest_api_id   = var.rest_api_id
  deployment_id = aws_api_gateway_deployment.deployment.id
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = var.rest_api_id

  # hack to force redeployment every time this hash changes
  triggers = {
    redeployment = sha1(join(",", var.required_resources))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_base_path_mapping" "ase_path_mapping" {
  count       = var.custom_domain_name == null ? 0 : 1
  stage_name  = var.include_stage_in_custom_domain ? aws_api_gateway_stage.stage.stage_name : null
  domain_name = var.custom_domain_name
  api_id      = var.rest_api_id
  base_path   = var.base_path
}
