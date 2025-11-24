#!/bin/bash
# Script para testar a API da UFSCar manualmente
# Use este script para diagnosticar problemas de conexão

echo "🧪 Testando conexão com API da UFSCar..."
echo ""

# Teste 1: Verificar conectividade básica
echo "1️⃣  Testando conectividade básica com a URL..."
curl -I https://sistemas.ufscar.br/sagui-api/siga/deferimento 2>&1 | head -5
echo ""

# Teste 2: Fazer requisição com credenciais de teste
echo "2️⃣  Testando POST com credenciais..."
echo "   (Substitua seu_email@ufscar.br e sua_senha pelos dados reais)"
echo ""

curl -X POST https://sistemas.ufscar.br/sagui-api/siga/deferimento \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"email":"seu_email@ufscar.br","senha":"sua_senha"}' \
  -v

echo ""
echo "✅ Teste concluído!"
echo ""
echo "📝 Análise:"
echo "   - Se receber Status 200: API retornou dados (sucesso)"
echo "   - Se receber Status 401/403: Credenciais inválidas"
echo "   - Se erro de conexão: Verificar URL ou conectividade da rede"
echo "   - Se CORS error: Pode estar bloqueado para requisições do navegador"
