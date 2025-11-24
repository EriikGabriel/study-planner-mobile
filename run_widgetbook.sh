#!/usr/bin/env bash

# 🚀 Quick Start Script for Widgetbook
# Execute este script para iniciar o Widgetbook rapidamente

set -e

echo "🎨 Study Planner - Widgetbook Quick Start"
echo "=========================================="
echo ""

# Verificar se está no diretório correto
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Erro: pubspec.yaml não encontrado"
    echo "Execute este script no diretório raiz do projeto"
    exit 1
fi

echo "📦 Obtendo dependências..."
flutter pub get

echo ""
echo "🎯 Iniciando Widgetbook..."
echo "   - Use Ctrl+C para parar"
echo ""
echo "📱 Dicas:"
echo "   1. Clique em 'Light' ou 'Dark' para mudar temas"
echo "   2. Selecione um dispositivo na barra lateral"
echo "   3. Ajuste a escala de texto para testar acessibilidade"
echo "   4. Explore as páginas em Pages > Login/Main/Activity"
echo "   5. Veja componentes isolados em Components > UI Elements"
echo ""

flutter run -t lib/widgetbook/widgetbook.dart
