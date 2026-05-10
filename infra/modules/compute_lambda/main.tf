# 1. Definición del Rol de IAM para la Lambda
resource "aws_iam_role" "lambda_role" {
  # Nombre con formato nombre-entorno-role
  name = "${var.name}-${var.environment}-role"

  # Política que permite que el servicio de Lambda "asuma" este rol
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  description = "Rol para la funcion lambda ${var.name} en el entorno ${var.environment}"
}

# 2. Política de ejecución básica
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 3. Definición de la función Lambda
resource "aws_lambda_function" "currency_converter" {
  # Nombre de la función basado en variables
  function_name = "${var.name}-${var.environment}"
  
  # Rol de IAM creado en el paso anterior
  role          = aws_iam_role.lambda_role.arn

  # Configuración del paquete de código
  filename         = "${path.module}/../../../app/function.zip"
  source_code_hash = filebase64sha256("${path.module}/../../../app/function.zip")

  handler       = "index.handler"
  runtime       = "nodejs22.x"
  memory_size   = var.memory_size
  architectures = var.architectures

  # Variable de entorno obligatoria
  environment {
    variables = {
      COMPUTE_TYPE = "lambda"
    }
  }
}

# 4. API HTTP
resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.name}-${var.environment}-api"
  protocol_type = "HTTP"
}

# 5. Integración entre API Gateway y la Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.currency_converter.invoke_arn
  
  payload_format_version = "2.0" 
}

# 6. Ruta para GET /rates
resource "aws_apigatewayv2_route" "get_rates" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /rates" 
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# 7. Ruta para POST /convert
resource "aws_apigatewayv2_route" "post_convert" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /convert" 
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# 8. Stage de despliegue
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default" 
  auto_deploy = true 
}

# 9. Permiso para que API Gateway invoque la Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.currency_converter.function_name
  principal     = "apigateway.amazonaws.com" # 
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
