variable "aws_region" {
  type        = string
  description = "Región de AWS donde se desplegarán los recursos"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Entorno de despliegue (ej. dev)"
}

variable "name" {
  type        = string
  description = "Nombre del proyecto"
}

variable "memory_size" {
  type        = number
  description = "Memoria para la Lambda"
}

variable "architectures" {
  type        = list(string)
  description = "Arquitectura de la Lambda"
}