import 'package:flutter/material.dart';
import 'package:trade_asia/infrastructure/constants/app_theme.dart';
import 'package:trade_asia/infrastructure/router/router.dart';
import 'package:trade_asia/infrastructure/service_locator/service_locator.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependencies with proper async initialization
  await configureDependencies();

  runApp(TradeAsiaApp());
}

class TradeAsiaApp extends StatelessWidget {
  TradeAsiaApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tradeasia Mobile',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
