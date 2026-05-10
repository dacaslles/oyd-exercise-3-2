variable "environment" {
  type        = string
  description = "El nombre del entorno (ej. dev, prod)"
}

variable "name" {
  type        = string
  description = "Nombre base para los recursos de la infraestructura"
}

variable "memory_size" {
  type        = number
  description = "Cantidad de memoria asignada a la función Lambda"
  default     = 128
}

variable "architectures" {
  type        = list(string)
  description = "Arquitectura de ejecución de la Lambda (arm64 o x86_64)"
  default     = ["arm64"]
  
  validation {
    condition     = contains([["arm64"], ["x86_64"]], var.architectures)
    error_message = "La arquitectura debe ser ['arm64'] o ['x86_64']."
  }
}