# variables.tf
variable "frontend_image_tag" {
  type        = string
  description = "Tag de l'image frontend"
}

variable "backend_image_tag" {
  type        = string
  description = "Tag de l'image backend"
}

