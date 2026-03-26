import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection.dart';
import 'core/router/router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force dark status bar for terminal aesthetic
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  await setupDI();
  runApp(const ProviderScope(child: RankeApp()));
}

class RankeApp extends StatelessWidget {
  const RankeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Apex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: goRouter,
    );
  }
}
