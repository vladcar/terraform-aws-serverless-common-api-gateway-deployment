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

variable "custom_domain_name" {
  type        = string
  default     = null
  description = "The already-registered domain name to connect the API to. Will create 'aws_api_gateway_base_path_mapping' if present and will do nothing if omitted"
}

variable "base_path" {
  type        = string
  default     = null
  description = "Path segment that must be prepended to the path when accessing the API via this custom_domain_name"
}
