
variable "myrg" {
    type        = string
    description = "Name of the resource group"
}

variable "myloc" {
    type        = string
    description = "Name of the resource location"
}

variable "myarc" {
    type        = string
    description = "Name of my azure container registery"
}

variable "web_app_name" {
    type        = string
    description = "Name of the web-app"
}

variable "app_service_plan_name" {
  type = string
    description = "Name of the App Service Plan"
}