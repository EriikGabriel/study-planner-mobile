# 📚 Guia Completo do Widgetbook - Study Planner

## O que é Widgetbook?

O **Widgetbook** é uma ferramenta de documentação e teste visual para componentes Flutter. Ele permite:

- 📱 Visualizar componentes em diferentes telas e dispositivos
- 🎨 Testar temas claro e escuro simultaneamente
- 📐 Verificar responsividade e adaptação de layouts
- 🔤 Testar diferentes escalas de texto
- 📋 Documentar o design system do aplicativo
- 🚀 Acelerar o desenvolvimento orientado por design

## Como Executar o Widgetbook

### Opção 1: Rodar em Desenvolvimento (Recomendado)

```bash
# Dentro do diretório do projeto
cd /home/erik/www/ufscar/mobile/study_planner

# Executar o Widgetbook
flutter run -t lib/widgetbook/widgetbook.dart
```

### Opção 2: Compilar para Web

```bash
flutter build web -t lib/widgetbook/widgetbook.dart
```

Após compilar, abrir `build/web/index.html` em um navegador.

## Estrutura do Projeto Widgetbook

```
lib/widgetbook/
├── widgetbook.dart              # Arquivo principal - PONTO DE ENTRADA
├── README.md                    # Documentação
├── stories/                     # Histórias dos componentes
│   ├── stories.dart            # Exportador central
│   ├── login_page_story.dart    # Story da página de login
│   ├── main_page_story.dart     # Story da página principal
│   ├── activity_page_story.dart # Story da página de atividades
│   └── components_story.dart    # Stories de componentes individuais
└── mocks/                       # Dados simulados para testes
    └── mock_data.dart          # Mocks de dados
```

## Funcionalidades Disponíveis no Widgetbook

### 1. 🎨 Temas (Light & Dark)

Alterne entre os temas claro e escuro usando o addon de tema no painel superior.

**Tema Claro:**

- Fundo: `#F5FBFF`
- Texto Primário: `#00394C`
- Cor Primária: `#2FD1C5`

**Tema Escuro:**

- Fundo: `#1D2428`
- Texto Primário: `#FFFFFF`
- Cor Primária: `#1ED760`

### 2. 📱 Dispositivos Testados

- **iOS:** iPhone SE, iPhone 13
- **Android:** Small Phone, Medium Phone

Selecione o dispositivo na barra de ferramentas para ver como a interface se adapta.

### 3. 🔤 Escala de Texto

Teste como seu aplicativo se comporta com diferentes tamanhos de fonte:

- 0.85x (texto pequeno)
- 1.0x (padrão)
- 1.15x (texto moderadamente grande)
- 1.3x (texto grande - acessibilidade)

### 4. 📦 Páginas Disponíveis

#### 📌 Login Page

- Formulário de login com Firebase
- Opções de autenticação
- Alternância de modo Sign In/Sign Up
- Seletor de idiomas

#### 📌 Main Page (Agenda)

- Navegação por abas (Agenda, Atividades, Notificações, Configurações)
- Seletor de mês
- Cards de tarefas com cores personalizadas
- Avatares de usuários

#### 📌 Activity Page

- Listagem de atividades
- Filtros por status (A Fazer, Concluído, Atrasado)
- Cards de atividade com ícones
- Botões de ação (editar, deletar)

### 5. 🧩 Componentes Disponíveis

#### Botões

- **Primary Button:** CTA principal do app
- **Secondary Button:** Botão secundário com borda

#### Cards

- **Activity Card:** Card padrão para atividades com ícone, título, descrição e horário

#### Text Fields

- **Email Input:** Campo de email com validação visual
- **Password Input:** Campo de senha com visibilidade toggle

## Como Adicionar Novas Stories

### Passo 1: Criar o Arquivo de Story

Crie um novo arquivo em `lib/widgetbook/stories/meu_componente_story.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:study_planner/components/meu_componente.dart';

final meuComponenteStory = WidgetbookComponent(
  name: 'Meu Componente',
  useCases: [
    WidgetbookUseCase(
      name: 'Padrão',
      builder: (context) => const MeuComponente(),
    ),
    WidgetbookUseCase(
      name: 'Variante 2',
      builder: (context) => const MeuComponente(variant: 2),
    ),
    WidgetbookUseCase(
      name: 'Estado Carregando',
      builder: (context) => const MeuComponente(isLoading: true),
    ),
  ],
);
```

### Passo 2: Exportar a Story

Adicione a exportação em `lib/widgetbook/stories/stories.dart`:

```dart
export 'meu_componente_story.dart';
```

### Passo 3: Adicionar ao Widgetbook Principal

No arquivo `lib/widgetbook/widgetbook.dart`, adicione a story ao diretório apropriado:

```dart
WidgetbookComponent(
  name: 'Meu Componente',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const MeuComponente(),
    ),
  ],
),
```

## 💡 Boas Práticas

### ✅ Faça

- Use casos de uso (useCases) para mostrar diferentes estados
- Teste todos os temas e dispositivos
- Mantenha stories simples e focadas
- Use nomes descritivos para useCases
- Inclua estados de carregamento, erro e sucesso

### ❌ Evite

- Stories muito complexas ou com muita lógica
- Dependências externas complexas
- Fazer requisições HTTP na story
- Usar dados aleatórios que mudem entre testes

## 🎯 Exemplos Práticos

### Exemplo 1: Story com Múltiplas Variantes

```dart
final botaoStory = WidgetbookComponent(
  name: 'Botão',
  useCases: [
    WidgetbookUseCase(
      name: 'Normal',
      builder: (context) => ElevatedButton(
        onPressed: () {},
        child: const Text('Clique aqui'),
      ),
    ),
    WidgetbookUseCase(
      name: 'Desabilitado',
      builder: (context) => const ElevatedButton(
        onPressed: null,
        child: Text('Desabilitado'),
      ),
    ),
    WidgetbookUseCase(
      name: 'Carregando',
      builder: (context) => ElevatedButton(
        onPressed: () {},
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    ),
  ],
);
```

### Exemplo 2: Story com Adaptação de Tela

```dart
final cartaoStory = WidgetbookComponent(
  name: 'Cartão',
  useCases: [
    WidgetbookUseCase(
      name: 'Padrão',
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: SizedBox(
              width: size.width > 600 ? 400 : double.infinity,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Conteúdo responsivo'),
              ),
            ),
          ),
        );
      },
    ),
  ],
);
```

## 🐛 Troubleshooting

### Problema: "Widgetbook not found"

**Solução:** Verifique se as dependências estão instaladas com `flutter pub get`

### Problema: Temas não estão mudando

**Solução:** Certifique-se que os temas estão sendo passados corretamente no `MaterialThemeAddon`

### Problema: Dispositivos não aparecem

**Solução:** Confirme que o `DeviceFrameAddon` está configurado corretamente

## 📖 Referências Úteis

- [Documentação Oficial do Widgetbook](https://widgetbook.io/)
- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design Guidelines](https://material.io/design)

## 🚀 Próximos Passos

1. Adicionar stories para todos os componentes
2. Criar mocks mais realistas para dados
3. Implementar testes de screenshot
4. Integrar com CI/CD para validar stories
5. Documentar padrões de design e guidelines

---

**Última atualização:** 10 de novembro de 2025
**Versão do Widgetbook:** 3.8.0
