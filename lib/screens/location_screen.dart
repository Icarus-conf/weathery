import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/text_format.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  LocationScreen(this.locationWeather);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  late int temp;
  late String weatherIcon;
  late String cityName;
  late String weatherMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temp = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        return;
      }

      double temperature = weatherData["main"]["temp"];
      temp = temperature.toInt();
      var condition = weatherData["weather"][0]["id"];
      weatherIcon = weather.getWeatherIcon(condition);

      // weatherMessage = weather.getMessage(temp);

      cityName = weatherData["name"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        var weatherData = await weather.getLocationWeather();
                        updateUI(weatherData);
                      },
                      child: Image.asset(
                        'images/update.png',
                        width: 50,
                        color: Color(0xFF003049),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var typedName = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CityScreen(),
                          ),
                        );
                        if (typedName != null) {
                          var weatherData =
                              await weather.getCityWeather(typedName);
                          updateUI(weatherData);
                        }
                      },
                      child: Image.asset(
                        'images/location.png',
                        width: 50,
                        color: Color(0xFF003049),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  PoppinsText(
                    text: '$temp°',
                    fontS: 100,
                    color: Color(0xFF003049),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Lottie.asset(
                    weatherIcon,
                    width: 200,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: PoppinsText(
                  text: cityName,
                  fontS: 25,
                  textAlign: TextAlign.center,
                  color: Color(0xFF003049),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
