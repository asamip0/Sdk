

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sdk/app_preference.dart';
import 'package:sdk/home_page.dart';

const String testPublicKey = 'test_public_key_dc74e0fd57cb46cd93832aee0a507256';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: '',
      enabledDebugging: true,
      builder: (context, navKey) {
        return ChangeNotifierProvider<AppPreferenceNotifier>(
          create: (_) => AppPreferenceNotifier(),
          builder: (context, _) {
            return Consumer<AppPreferenceNotifier>(
              builder: (context, appPreference, _) {
                return MaterialApp(
                  title: 'Khalti Payment Gateway',
                  supportedLocales: const [
                    Locale('en', 'US'),
                    Locale('ne', 'NP'),
                  ],
                  locale: appPreference.locale,
                  theme: ThemeData(
                    brightness: appPreference.brightness,
                    primarySwatch: Colors.deepPurple,
                    pageTransitionsTheme: const PageTransitionsTheme(
                      builders: {
                        TargetPlatform.android: ZoomPageTransitionsBuilder(),
                      },
                    ),
                  ),
                  debugShowCheckedModeBanner: false,
                  navigatorKey: navKey,
                  localizationsDelegates: const [
                    KhaltiLocalizations.delegate,
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  routes: {
                    '/': (_) => const HomePage(key: Key('home')),
                  },
                  onGenerateInitialRoutes: (route) {
                    // Only used for handling response from KPG in Flutter Web.
                    if (route.startsWith('/kpg/')) {
                      final uri = Uri.parse('https://khalti.com$route');
                      return [
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            key: const Key('kpg-home'),
                            params: uri.queryParameters,
                          ),
                        ),
                      ];
                    }
                    return Navigator.defaultGenerateInitialRoutes(
                      navKey.currentState!,
                      route,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}