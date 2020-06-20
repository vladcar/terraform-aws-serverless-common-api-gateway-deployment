# AWS API Gateway Deployment module

Should be used with [serverless-common-api-gateway-method](https://github.com/vladcar/terraform-aws-serverless-common-api-gateway-method).

#### Intended usage:

```hcl-terraform

resource "aws_api_gateway_rest_api" "api" {
  name = "my-api"
}

resource "aws_api_gateway_resource" "root_resource" {
  path_part   = "path"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

module "proxy_get_endpoint" {
  source            = "vladcar/serverless-common-api_gateway_method/aws"
  http_method       = "GET"
  resource_path     = aws_api_gateway_resource.root_resource.path_part
  resource_id       = aws_api_gateway_resource.root_resource.id
  rest_api_id       = aws_api_gateway_rest_api.api.id
  validator_id      = aws_api_gateway_request_validator.validator.id
  lambda_invoke_arn = var.you_lambda_invoke_arn
}

module "async_post_endpoint" {
  source                          = "vladcar/serverless-common-api_gateway_method/aws"
  http_method                     = "POST"
  integration_type                = "AWS"
  integration_http_method         = "POST"
  async_response_status_code      = "202"
  resource_path                   = aws_api_gateway_resource.prospect_resource.path_part
  resource_id                     = aws_api_gateway_resource.prospect_resource.id
  rest_api_id                     = aws_api_gateway_rest_api.api.id
  validator_id                    = aws_api_gateway_request_validator.validator.id
  lambda_invoke_arn               = var.you_lambda_invoke_arn
  enable_async_lambda_integration = true
}

module "deployment" {
  source      = "vladcar/serverless-common-api_gateway_deployment/aws"
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage       = var.stage

  # this is the key to ensure api gateway is redeployed correctly when something changes in integration/method
  required_resources = [
    module.async_post_endpoint.integration_hash,
    module.proxy_get_endpoint.integration_hash,
  ]
}

```

Anything can be passed to `required_resources`, these values simply force redeployment of the gateway so in theory they can be any value that changes together with resources/integrations/methods.

[serverless-common-api-gateway-method](https://github.com/vladcar/terraform-aws-serverless-common-api-gateway-method) module outputs `integration_hash` which is the random uuid generated when something changes. It is recommended to use this value in `required_resources`.  