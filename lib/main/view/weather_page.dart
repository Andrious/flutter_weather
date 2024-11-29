// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_weather/search/search.dart';
// import 'package:flutter_weather/settings/view_settings.dart';
// import 'package:flutter_weather/weather/weather.dart';

import '/src/controller.dart';

import '/src/model.dart';

import '/src/view.dart';

///
class WeatherPage extends StatefulWidget {
  ///
  const WeatherPage({super.key});
  @override
  State<StatefulWidget> createState() => _WeatherPageState();
}

class _WeatherPageState extends StateX<WeatherPage> {
  _WeatherPageState()
      : super(controller: WeatherController(), useInherited: true) {
    con = controller as WeatherController;
  }

  late WeatherController con;

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push<void>(
              SettingsPage.route(),
            ),
          ),
          AppMenu(),
        ],
      ),
      body: Center(
        // Only this part of the interface will ever rebuild.
        child: setBuilder(
          (_) {
            final status = con.weatherStatus;
            switch (status) {
              case WeatherStatus.initial:
                return const WeatherEmpty();
              case WeatherStatus.loading:
                return const WeatherLoading();
              case WeatherStatus.failure:
                return const WeatherError();
              case WeatherStatus.success:
                final state = con.stateOfWeather;
                return WeatherPopulated(
                  weather: state.weather,
                  units: state.temperatureUnits,
                  onRefresh: () {
                    return con.refreshWeather();
                  },
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search, semanticLabel: 'Search'),
        onPressed: () async {
          final city = await Navigator.of(context).push(SearchPage.route());
          if (context.mounted) {
            await con.fetchWeather(city);
          }
        },
      ),
    );
  }

  /// Set it to return false and try a new city. It won't work.
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
