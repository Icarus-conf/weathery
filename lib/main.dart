import 'package:flutter/material.dart';
import 'package:clima/screens/loading_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.grey[200],
            ),
            darkTheme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Color(0xFF293236),
            ),
            themeMode: currentMode,
            home: const LoadingScreen(),
          );
        });
  }
}
