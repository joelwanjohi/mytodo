import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytodo/firebase_options.dart';
import 'package:mytodo/screens/splash_screen.dart';
import 'package:mytodo/theme/theme.dart';
import 'package:signals/signals_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MainEntry()));
}

class MainEntry extends ConsumerWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Get ur Tasks Done',
      theme: sIsDark.watch(context)
          ? cThemeDark.watch(context)
          : cThemeLight.watch(context),
      home: const SplashScreen(),
    );
  }
}
