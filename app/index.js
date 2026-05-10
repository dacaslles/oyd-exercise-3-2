'use strict';

const RATES = {
  USD: 1.0,
  EUR: 0.92,
  GBP: 0.79,
  JPY: 149.50,
  GTQ: 7.78
};

exports.handler = async (event) => {
  const method = event.requestContext?.http?.method;
  const path = event.rawPath;

  // Ruta para obtener las tasas de cambio
  if (method === 'GET' && path === '/rates') {
    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ rates: RATES })
    };
  }

  // Ruta para convertir divisas
  if (method === 'POST' && path === '/convert') {
    const { from, to, amount } = JSON.parse(event.body || '{}');

    if (!RATES[from] || !RATES[to] || !amount) {
      return {
        statusCode: 400,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ error: 'from, to and amount are required' })
      };
    }

    const result = (amount / RATES[from]) * RATES[to];
    
    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        from,
        to,
        amount,
        result: Math.round(result * 100) / 100
      })
    };
  }

  // Ruta por defecto si no coincide ninguna anterior
  return {
    statusCode: 404,
    body: JSON.stringify({ error: 'not found' })
  };
};