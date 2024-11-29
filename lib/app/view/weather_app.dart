// ignore_for_file: unnecessary_overrides
import '/src/controller.dart';

import '/src/model.dart' as m;

import '/src/view.dart';

import 'package:weather_repository/weather_repository.dart' as r;

/// App
class WeatherApp extends AppStatefulWidget {
  ///
  WeatherApp({super.key});
  // This is the 'App State object' of the application.
  @override
  AppState createAppState() => _WeatherAppState();
}

/// This is the 'View' of the application.
/// The 'look and behavior' of the app.
///
class _WeatherAppState extends AppState {
  _WeatherAppState()
      : super(
          controller: WeatherAppController(),
          debugShowCheckedModeBanner: false,
          useRouterConfig: WeatherAppController().useRouterConfig,
          errorScreen: defaultErrorWidgetBuilder,
          inTheme: () => ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: WeatherController().weather.toColor,
            ),
            textTheme: GoogleFonts.rajdhaniTextTheme(),
          ),
          onNavigationNotification: (notification) {
            if (kDebugMode) {
              debugPrint('############ Event: onNavigationNotification()');
            }
            return notification.canHandlePop;
          },
          inSupportedLocales: () {
            /// The app's translations
            L10n.translations = {
              const Locale('zh', 'CN'): m.zhCN,
              const Locale('fr', 'FR'): m.frFR,
              const Locale('de', 'DE'): m.deDE,
              const Locale('he', 'IL'): m.heIL,
              const Locale('ru', 'RU'): m.ruRU,
              const Locale('es', 'AR'): m.esAR,
            };
            return L10n.supportedLocales;
          },
          localizationsDelegates: [
            L10n.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          inErrorHandler: (details) {
            //
            final appState = App.appState!;
            // You see? appState is this object!
            assert(() {
              if (appState is _WeatherAppState) {
                debugPrint(
                    '=========== inErrorHandler: appState is _ExampleAppState');
              }
              return true;
            }());

            // Retrieve the last Flutter Error that has occurred.
            var lastErrorDetails = appState.lastFlutterErrorDetails;

            // Retrieve the last Flutter Error that has occurred.
            // Note, this function retrieves and then 'clears' the last error from storage.
            lastErrorDetails = appState.lastFlutterError();

            // This, of course, will be the same. It's this very error that's caught here.
            if (details == lastErrorDetails) {
              debugPrint(
                  '=========== inErrorHandler: details == lastErrorDetails');
            }
          },
          home: const WeatherPage(),
        );

  ///
  @override
  bool onOnNavigationNotification(notification) {
    if (kDebugMode) {
      debugPrint('############ Event: Navigation change.');
    }
    return notification.canHandlePop;
  }

  /// Place a breakpoint here and see how it works
  @override
  Widget build(BuildContext context) => super.build(context);

  @override
  void onErrorHandler(FlutterErrorDetails details) {
    //
    final appState = App.appState!;
    // You see? appState is this object!
    assert(() {
      // ignore: unnecessary_type_check
      if (this is _WeatherAppState && appState is _WeatherAppState) {
        debugPrint(
            '=========== onErrorHandler: this is _ExampleAppState && appState is _ExampleAppState');
      }
      return true;
    }());

    // Retrieve the last Flutter Error that has occurred.
    final lastErrorDetails = lastFlutterErrorDetails;

    // You see? appState is this object!
    assert(() {
      if (lastErrorDetails != null &&
          details.exception == lastErrorDetails.exception &&
          lastFlutterErrorMessage ==
              'Exception: Fake error to demonstrate error handling!') {
        debugPrint(
            '=========== onErrorHandler(): details.exception == lastErrorDetails.exception');
      }
      return true;
    }());
  }

  @override
  void onError(FlutterErrorDetails details) {
    // This is the app's State object's error routine.
    super.onError(details);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return super.updateShouldNotify(oldWidget);
  }

  @override
  bool dependOnInheritedWidget(BuildContext? context) {
    return super.dependOnInheritedWidget(context);
  }

  @override
  void deactivate() {
    // Place a breakpoint to see how this works
    super.deactivate();
  }

  @override
  void dispose() {
    // Place a breakpoint to see how this works
    super.dispose();
  }
}

extension on m.Weather {
  Color get toColor {
    switch (condition) {
      case r.WeatherCondition.clear:
        return Colors.yellow;
      case r.WeatherCondition.snowy:
        return Colors.lightBlueAccent;
      case r.WeatherCondition.cloudy:
        return Colors.blueGrey;
      case r.WeatherCondition.rainy:
        return Colors.indigoAccent;
      case r.WeatherCondition.unknown:
        return Colors.cyan;
    }
  }
}
