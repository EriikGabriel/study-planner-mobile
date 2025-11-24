# Widgetbook - Study Planner

## O que é Widgetbook?

O Widgetbook é uma ferramenta para documentar, visualizar e testar componentes e páginas do Flutter de forma isolada. É perfeito para:

- Testar componentes em diferentes temas (claro/escuro)
- Visualizar responsividade em diferentes tamanhos de tela
- Documentar a interface do aplicativo
- Testar a acessibilidade

## Como executar o Widgetbook

```bash
# Para iniciar o Widgetbook em desenvolvimento
flutter run -t lib/widgetbook/widgetbook.dart

# Para construir para web
flutter build web -t lib/widgetbook/widgetbook.dart
```

## Estrutura do Widgetbook

```
lib/widgetbook/
├── widgetbook.dart          # Arquivo principal do Widgetbook
├── stories/                  # Histórias dos componentes
│   ├── login_page_story.dart
│   ├── main_page_story.dart
│   ├── activity_page_story.dart
│   └── stories.dart         # Exportador de todas as stories
└── mocks/                   # Mocks para dados de teste
```

## Funcionalidades disponíveis

### 1. **Temas (Light/Dark)**

Você pode alternar entre os temas claro e escuro usando o addon de temas do Widgetbook.

### 2. **Dispositivos**

Teste sua interface em diferentes dispositivos:

- iPhone SE, iPhone 13, iPhone 14 (iOS)
- Small, Medium e Large phones (Android)

### 3. **Escala de Texto**

Teste como sua interface se adapta com diferentes escalas de texto: 0.85x, 1.0x, 1.15x, 1.3x

## Stories criadas

### Login Page Story

- Exibe a página de login em formato isolado
- Útil para testar a interface de autenticação

### Main Page Story

- Mostra a página principal com navegação
- Testa a responsividade do layout

### Activity Page Story

- Exibe a página de atividades
- Mostra como as atividades são listadas

## Como adicionar novas stories

1. Crie um novo arquivo em `lib/widgetbook/stories/`:

```dart
import 'package:widgetbook/widgetbook.dart';
import 'package:study_planner/pages/seu_componente.dart';

final seuComponenteStory = WidgetbookComponent(
  name: 'Seu Componente',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        return SeuComponente();
      },
    ),
    WidgetbookUseCase(
      name: 'Variant 2',
      builder: (context) {
        return SeuComponente(variant: 2);
      },
    ),
  ],
);
```

2. Exporte a story em `lib/widgetbook/stories/stories.dart`:

```dart
export 'seu_componente_story.dart';
```

3. Adicione a story ao arquivo principal `lib/widgetbook/widgetbook.dart`:

```dart
WidgetbookFolder(
  name: 'Components',
  widgets: [
    seuComponenteStory,
  ],
),
```
