import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  double temperature;
  String cityName;
  String weatherIcon;
  String weatherMessage;

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherDataFuture) async {
    final weatherData = await weatherDataFuture;

    setState(() {
      temperature = (weatherData['main']['temp']) - 273.15;
      cityName = weatherData['name'];
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature.toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  onPressed: () async {
                    var weatherData = await weather.getLocationWeather();
                    updateUI(weatherData);
                  },
                  child: Icon(
                    Icons.near_me,
                    size: 50.0,
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    var typedName = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CityScreen(),
                      ),
                    );

                    if (typedName != null) {
                      var weatherData = await weather.getCityWeather(typedName);
                      updateUI(weatherData);
                    }
                  },
                  child: Icon(
                    Icons.location_city,
                    size: 50.0,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                children: <Widget>[
                  Text(
                    '${temperature.toInt()}°',
                    style: kTempTextStyle,
                  ),
                  Expanded(
                    child: Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Text(
                '$weatherMessage in $cityName!',
                textAlign: TextAlign.right,
                style: kMessageTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
