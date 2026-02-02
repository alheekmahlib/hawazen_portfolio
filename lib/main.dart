import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'app.dart';
import 'core/l10n/locale_controller.dart';
import 'features/admin/state/admin_controller.dart';
import 'features/content/data/content_repository.dart';
import 'features/content/state/content_controller.dart';
import 'features/portfolio/state/portfolio_scroll_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final repo = ContentRepository();
  Get.put<LocaleController>(LocaleController(), permanent: true);
  Get.put<ContentRepository>(repo, permanent: true);
  Get.put<ContentController>(
    ContentController(repository: repo),
    permanent: true,
  );
  Get.put<AdminController>(AdminController(repository: repo), permanent: true);
  Get.put<PortfolioScrollController>(
    PortfolioScrollController(),
    permanent: true,
  );

  runApp(const App());
}
