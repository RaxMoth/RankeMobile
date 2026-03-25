import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/router.dart';
import 'core/di/injection.dart';
=======
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection.dart';
import 'core/router/router.dart';
>>>>>>> 88d3438 (good progress)
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD
  setupDI();
  runApp(const ProviderScope(child: RankeApp()));
}

class RankeApp extends ConsumerWidget {
=======

  // Force dark status bar for terminal aesthetic
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  await setupDI();
  runApp(const ProviderScope(child: RankeApp()));
}

class RankeApp extends StatelessWidget {
>>>>>>> 88d3438 (good progress)
  const RankeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
<<<<<<< HEAD
      title: 'Ranke',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
=======
      title: 'Apex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: goRouter,
>>>>>>> 88d3438 (good progress)
    );
  }
}
