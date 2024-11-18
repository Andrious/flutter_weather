// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_weather/weather/weather.dart';

import '/src/controller.dart';

import '/src/model.dart';


class SettingsPage extends StatelessWidget {
  SettingsPage._() : con = WeatherController();

  final WeatherController con;

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => SettingsPage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <Widget>[
          // BlocBuilder<WeatherCubit, WeatherState>(
          //   buildWhen: (previous, current) =>
          //       previous.temperatureUnits != current.temperatureUnits,
          //   builder: (context, state) {
          //     return ListTile(
          //       title: const Text('Temperature Units'),
          //       isThreeLine: true,
          //       subtitle: const Text(
          //         'Use metric measurements for temperature units.',
          //       ),
          //       trailing: Switch(
          //         value: state.temperatureUnits.isCelsius,
          //         onChanged: (_) => context.read<WeatherCubit>().toggleUnits(),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            title: const Text('Temperature Units'),
            isThreeLine: true,
            subtitle:
                const Text('Use metric measurements for temperature units.'),
            // Call con.setState((){}) will call this builder again.
            trailing: con.setBuilder(
              (_) => Switch(
                value: con.weatherState.temperatureUnits.isCelsius,
                onChanged: (_) => con.toggleUnits(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}