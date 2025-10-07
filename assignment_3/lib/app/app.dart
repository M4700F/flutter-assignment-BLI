import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/router.dart';
import '../features/settings/providers/settings_provider.dart';
import '../core/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settingsAsync = ref.watch(settingsProvider);
    
    return settingsAsync.when(
      data: (settings) => MaterialApp.router(
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(settings.fontSize),
        darkTheme: AppTheme.darkTheme(settings.fontSize),
        themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        routerConfig: router,
      ),
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error loading settings: $error'),
          ),
        ),
      ),
    );
  }
}