import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_planner/pages/activity_page.dart';
import 'package:widgetbook/widgetbook.dart';

final activityPageStory = WidgetbookComponent(
  name: 'Activity Page',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        return const ProviderScope(child: ActivityPage());
      },
    ),
  ],
);
