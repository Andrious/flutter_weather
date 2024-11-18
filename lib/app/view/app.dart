//
import '/src/controller.dart';

import '/src/model.dart' as m;

import '/src/view.dart';

import 'package:weather_repository/weather_repository.dart' as r;

/// App
class FlutteryExampleApp extends AppStatefulWidget {
  FlutteryExampleApp({super.key});
  // This is the 'App State object' of the application.
  @override
  AppState createAppState() => _ExampleAppState();
}

/// This is the 'View' of the application.
/// The 'look and behavior' of the app.
///
class _ExampleAppState extends AppState {
  _ExampleAppState()
      : super(
          controller: ExampleAppController(),
          inTitle: () => 'Demo App',
          debugShowCheckedModeBanner: false,
          switchUI: ExampleAppController().switchUI,
          useRouterConfig: ExampleAppController().useRouterConfig,
          errorScreen: defaultErrorWidgetBuilder,
          inTheme: () {
            m.Weather weather = WeatherController().weatherState.weather;
            final seedColor = weather.toColor;
            return ThemeData(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
              textTheme: GoogleFonts.rajdhaniTextTheme(),
            );
          },
          onNavigationNotification: (notification) {
            if (kDebugMode) {
              debugPrint('############ Event: onNavigationNotification()');
            }
            return notification.canHandlePop;
          },
          onUnknownRoute: (settings) {
            Route<dynamic>? route;
            if (kDebugMode) {
              debugPrint('############ Event: onUnknownRoute()');
            }
            return route;
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
          allowChangeTheme: true, // Allow the App's theme to change
          allowChangeLocale: true, // Allow the app to change locale
          allowChangeUI: true, // Allow the app to change its design interface
          inInitAsync: () => Future.value(true), // Demonstration purposes
          inInitState: () {/* Optional inInitState() function */},
          inErrorHandler: (details) {
            //
            final appState = App.appState!;
            // You see? appState is this object!
            assert(() {
              if (appState is _ExampleAppState) {
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
          inHome: () => const WeatherPage(),
        );

  @override
  onOnNavigationNotification(notification) {
    if (kDebugMode) {
      debugPrint('############ Event: Navigation change.');
    }
    return notification.canHandlePop;
  }

  /// Place a breakpoint here and see how it works
  @override
  Widget build(BuildContext context) => super.build(context);

  @override
  // ignore: unnecessary_overrides
  void onErrorHandler(FlutterErrorDetails details) {
    //
    final appState = App.appState!;
    // You see? appState is this object!
    assert(() {
      // ignore: unnecessary_type_check
      if (this is _ExampleAppState && appState is _ExampleAppState) {
        debugPrint(
            '=========== onErrorHandler: this is _ExampleAppState && appState is _ExampleAppState');
      }
      return true;
    }());

    // Retrieve the last Flutter Error that has occurred.
    var lastErrorDetails = lastFlutterErrorDetails;

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
  // ignore: unnecessary_overrides
  void onError(FlutterErrorDetails details) {
    // This is the app's State object's error routine.
    super.onError(details);
  }

  @override
  // ignore: unnecessary_overrides
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return super.updateShouldNotify(oldWidget);
  }

  @override
  // ignore: unnecessary_overrides
  bool dependOnInheritedWidget(BuildContext? context) {
    return super.dependOnInheritedWidget(context);
  }

  @override
  // ignore: unnecessary_overrides
  void deactivate() {
    // Place a breakpoint to see how this works
    super.deactivate();
  }

  @override
  // ignore: unnecessary_overrides
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
