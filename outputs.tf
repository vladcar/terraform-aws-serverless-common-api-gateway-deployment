output "deployment_stage_name" {
  value = aws_api_gateway_deployment.deployment.stage_name
}

output "invoke_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}
