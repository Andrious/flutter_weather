//
import 'package:fluttery_framework/controller.dart' as c;

import '/src/model.dart' show Settings;

// You can see 'at a glance' this Controller also 'talks to' the interface (View).
import '/src/view.dart';

///
class AppController extends c.AppController {
  ///
  factory AppController() => _this ??= AppController._();
  AppController._();
  static AppController? _this;

  /// Error in builder()
  bool errorInBuilder = false;

  /// Store the boolean allowing for errors or not.
  bool initAsyncError = false;

  /// Error right at the start
  bool errorAtStartup = false;


  /// **************  Life cycle events ****************

  @override
  void initState() {
    super.initState();
    assert(() {
      debugPrint('############ Event: didChangeLocale() in $this');
      return true;
    }());
  }

  /// Called to complete any asynchronous operations.
  @override
  Future<bool> initAsync() async {
    final init = await super.initAsync();
    //
    if (initAsyncError) {
      initAsyncError = false;
      throw Exception('Error in initAsync()!');
    }

    if (inDebugMode) {
      debugPrint('############ Event: initAsync() in $this');
    }
    return init;
  }

  /// The framework calls this method when the [StateX] object removed from widget tree.
  /// i.e. The screen is closed.
  @override
  void deactivate() {
    if (inDebugMode) {
      debugPrint('############ Event: deactivate() in $this');
    }
  }

  /// Called when this State object was removed from widget tree for some reason
  /// Undo what was done when [deactivate] was called.
  @override
  void activate() {
    if (inDebugMode) {
      debugPrint('############ Event: activate() in $this');
    }
  }

  /// The framework calls this method when this [StateX] object will never
  /// build again.
  /// Note: YOU DON'T KNOW WHEN THIS WILL RUN in the Framework.
  /// PERFORM ANY TIME-CRITICAL OPERATION IN deactivate() INSTEAD!
  @override
  void dispose() {
    if (inDebugMode) {
      debugPrint('############ Event: dispose() in $this');
    }
    super.dispose();
  }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedAppLifecycleState() {
    if (inDebugMode) {
      debugPrint('############ Event: pausedLifecycleState() in $this');
    }
  }

  /// Called when app returns from the background
  @override
  void resumedAppLifecycleState() {
    if (inDebugMode) {
      debugPrint('############ Event: resumedLifecycleState() in $this');
    }
  }

  /// The application is in an inactive state and is not receiving user input.
  @override
  void inactiveAppLifecycleState() {
    if (inDebugMode) {
      debugPrint('############ Event: inactiveLifecycleState() in $this');
    }
  }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  void detachedAppLifecycleState() {
    if (inDebugMode) {
      debugPrint('############ Event: detachedLifecycleState() in $this');
    }
  }

  /// Override this method to respond when the [StatefulWidget] is recreated.
  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    if (inDebugMode) {
      debugPrint('############ Event: didUpdateWidget() in $this');
    }
  }

  /// Called when this [StateX] object is first created immediately after [initState].
  /// Otherwise called only if this [State] object's Widget
  /// is a dependency of [InheritedWidget].
  @override
  void didChangeDependencies() {
    if (inDebugMode) {
      debugPrint('############ Event: didChangeDependencies() in $this');
    }
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  @override
  void reassemble() {
    if (inDebugMode) {
      debugPrint('############ Event: reassemble() in $this');
    }
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  @override
  Future<bool> didPopRoute() async {
    if (inDebugMode) {
      debugPrint('############ Event: didPopRoute() in $this');
    }
    return super.didPopRoute();
  }

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    if (inDebugMode) {
      debugPrint('############ Event: didPushRouteInformation() in $this');
    }
    return super.didPushRouteInformation(routeInformation);
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {
    assert(() {
      debugPrint('############ Event: didChangeMetrics() in $this');
      return true;
    }());
  }

  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {
    assert(() {
      debugPrint('############ Event: didChangeTextScaleFactor() in $this');
      return true;
    }());
  }

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {
    assert(() {
      debugPrint('############ Event: didChangePlatformBrightness() in $this');
      return true;
    }());
  }

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocales(List<Locale>? locales) {
    assert(() {
      debugPrint('############ Event: didChangeLocale() in $this');
      return true;
    }());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.detach
    /// AppLifecycleState.resume
    assert(() {
      debugPrint(
          '############ Event: didChangeAppLifecycleState() in ${this.state} for $this');
      return true;
    }());
  }

  /// Called when the system is running low on memory.
  @override
  void didHaveMemoryPressure() {
    assert(() {
      debugPrint('############ Event: didHaveMemoryPressure() in $this');
      return true;
    }());
  }

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() {
    assert(() {
      debugPrint(
          '############ Event: didChangeAccessibilityFeatures() in $this');
      return true;
    }());
  }
}
