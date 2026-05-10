output "invoke_url" {
  value       = aws_apigatewayv2_stage.default.invoke_url
  description = "La URL base para invocar los endpoints de la API Gateway"
}