//

import '/src/controller.dart';

import '/src/model.dart' as m;

import '/src/view.dart';

import 'package:weather_repository/weather_repository.dart' as repo;

///
class WeatherController extends StateXController {
  ///
  factory WeatherController() => _this ??= WeatherController._();

  WeatherController._()
      : _weatherRepository = repo.WeatherRepository(),
        _weatherState = m.WeatherState();

  static WeatherController? _this;

  final repo.WeatherRepository _weatherRepository;

  /// Immutable access to the State of Weather object
  m.WeatherState get stateOfWeather => _weatherState;

  /// Immutable access to the State of Weather object
  m.WeatherStatus get weatherStatus => _weatherState.status;

  /// State of the weather
  m.WeatherState _weatherState;

  static const _cityKey = 'weather_city';

  static const _unitKey = 'temperature_units';

  /// Called to complete any asynchronous operations.
  @override
  Future<bool> initAsync() async {
    //
    final init = await super.initAsync();

    //
    final isCelsius = Prefs.getBool(_unitKey, true);

    if (!isCelsius) {
      _weatherState = _weatherState.copyWith(
          temperatureUnits: m.TemperatureUnits.fahrenheit);
    }

    //
    final city = Prefs.getString(_cityKey);

    if (city.isNotEmpty) {
      //
      await _weatherUpdate(city);
    }

    //
    state?.add(MaterialController());

    if (inDebugMode) {
      debugPrint('############ Event: initAsync() in $this');
    }

    return init;
  }

  /// Supply the Weather data object
  m.Weather get weather => _weatherState.weather;

  /// Fetch the weather from the specified city via a public API
  Future<void> fetchWeather(String? city) async {
    //
    if (city == null || city.trim().isEmpty) {
      return;
    }

    // emit(weatherState.copyWith(status: m.WeatherStatus.loading));
    _weatherState = m.WeatherState(
      status: m.WeatherStatus.loading,
      weather: _weatherState.weather,
    );

    // Display the loading status
    setState(() {});

    //
    await _weatherUpdate(city);
  }

  ///
  Future<void> refreshWeather() async {
    //
    if (!_weatherState.status.isSuccess) {
      return;
    }
    //
    if (_weatherState.weather == m.Weather.empty) {
      return;
    }
    //
    await _weatherUpdate(_weatherState.weather.location);
  }

  //
  Future<void> _weatherUpdate(String? city) async {
    //
    if (city == null || city.trim().isEmpty) {
      return;
    }

    bool conditionChange = false;

    try {
      //
      final repo.Weather w = await _weatherRepository.getWeather(city);

      final weather = m.Weather.fromRepository(w);

      final units = _weatherState.temperatureUnits;

      final value = units.isFahrenheit
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;

      conditionChange = _weatherState.weather.condition != weather.condition;

      // emit(
      //   weatherState.copyWith(
      //     status: m.WeatherStatus.success,
      //     temperatureUnits: units,
      //     weather: weather.copyWith(temperature: m.Temperature(value: value)),
      //   ),
      // );
      _weatherState = m.WeatherState(
        status: m.WeatherStatus.success,
        temperatureUnits: units,
        weather: weather.copyWith(temperature: m.Temperature(value: value)),
      );
    } on Exception {
      // emit(weatherState.copyWith(status: m.WeatherStatus.failure));
      _weatherState = _weatherState.copyWith(status: m.WeatherStatus.failure);
    }

    // Save the location
    await Prefs.setString(_cityKey, _weatherState.weather.location);

    // Update the location and temperature
    setState(() {});

    // Update the background color.
    if(conditionChange) {
      rootState?.setState(() {});
    }
  }

  /// Determine if Celsius is used or not
  bool get isCelsius => _weatherState.temperatureUnits.isCelsius;

  ///
  void toggleUnits() {
    //
    // Save temperature units to be used
    Prefs.setBool(_unitKey, !_weatherState.temperatureUnits.isCelsius);

    final units = _weatherState.temperatureUnits.isFahrenheit
        ? m.TemperatureUnits.celsius
        : m.TemperatureUnits.fahrenheit;

    if (!_weatherState.status.isSuccess) {
      // emit(state.copyWith(temperatureUnits: units));
      _weatherState = _weatherState.copyWith(temperatureUnits: units);
      setState(() {});
      return;
    }

    final weather = _weatherState.weather;

    if (weather != m.Weather.empty) {
      //
      final temperature = weather.temperature;

      final value = units.isCelsius
          ? temperature.value.toCelsius()
          : temperature.value.toFahrenheit();
      // emit(
      //   state.copyWith(
      //     temperatureUnits: units,
      //     weather: weather.copyWith(temperature: Temperature(value: value)),
      //   ),
      // );
      _weatherState = _weatherState.copyWith(
        temperatureUnits: units,
        weather: weather.copyWith(
          temperature: m.Temperature(value: value),
        ),
      );
      //
      setState(() {});
    }
  }

  /// **************  Life cycle events ****************

  /// The framework calls this method when the [StateX] object removed from widget tree.
  /// i.e. The screen is closed.
  @override
  void deactivate() {
    //
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
    if (inDebugMode) {
      debugPrint('############ Event: didChangeMetrics() in $this');
    }
  }

  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {
    if (inDebugMode) {
      debugPrint('############ Event: didChangeTextScaleFactor() in $this');
    }
  }

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {
    if (inDebugMode) {
      debugPrint('############ Event: didChangePlatformBrightness() in $this');
    }
  }

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocales(List<Locale>? locales) {
    if (inDebugMode) {
      debugPrint('############ Event: didChangeLocale() in $this');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.inactive (may be paused at any time)
  }
}

/// Readily perform the conversion of a double value in this app.
extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
  double toCelsius() => (this - 32) * 5 / 9;
}
