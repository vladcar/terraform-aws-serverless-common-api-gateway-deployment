variable "stage" {
  description = "Deployment stage name"
}

variable "required_resources" {
  type        = list(string)
  description = "List of resources required for this deployment. Values of this list are used in hash function that triggers redeployment when changed."
}

variable "rest_api_id" {
  type        = string
  description = "aws_api_gateway id"
}