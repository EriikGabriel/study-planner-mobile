import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_planner/pages/main_page.dart';
import 'package:widgetbook/widgetbook.dart';

final mainPageStory = WidgetbookComponent(
  name: 'Main Page',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        return const ProviderScope(child: MainPage());
      },
    ),
  ],
);
