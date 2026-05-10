# Exercise 3.2 - Lambda Currency Converter

## Evidence

A continuación se detallan los datos técnicos de la función desplegada, obtenidos mediante el comando `aws lambda get-function`:

```json
{
    "FunctionArn": "arn:aws:lambda:us-east-1:144986448284:function:oyd-converter-dev",
    "State": "Active",
    "Arch": [
        "arm64"
    ]
}
```

## Pruebas de Funcionamiento

Se validó el correcto funcionamiento de los endpoints utilizando la URL de invocación generada por Terraform.

### 1. Obtener Tasas de Cambio (`GET /rates`)

**Comando:**

```bash
curl ${INVOKE_URL}/rates
```

**Resultado esperado:**

```bash
StatusCode        : 200
StatusDescription : OK
Content           : {"rates":{"USD":1,"EUR":0.92,"GBP":0.79,"JPY":149.5,"GTQ":7.78}}
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Apigw-Requestid: dKlrRgxHIAMEb5A=
                    Content-Length: 64
                    Content-Type: application/json
                    Date: Sun, 10 May 2026 20:24:27 GMT
                    
                    {"rates":{"USD":1,"EUR":0.92,"GBP...
Forms             : {}
Headers           : {[Connection, keep-alive], [Apigw-Requestid, dKlrRgxHIAMEb5A=], [Content-Length, 64], [Content-Type, application/json]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 64
```

### 2. Conversión de Divisas (`POST /convert`)

**Comando:**

```bash
curl -X POST ${INVOKE_URL}/convert \
-H "Content-Type: application/json" \
-d '{"from":"USD", "to":"GTQ", "amount":100}'
```

**Resultado esperado:**

```bash
from to  amount result
---- --  ------ ------
USD  GTQ    100    778
```
