variable "create_cognito" {
    type = bool
    description = "true/false"
    default = false  
}
variable "Environment" {
    type = string
    description = "select an Environment"
}
variable "region" {
  type        = string
  description = "AWS Region name"
  default     = "us-east-1"
}

variable "domain" {
  type        = string
  description = "AWS Region name"
  default     = "ravik"
}

