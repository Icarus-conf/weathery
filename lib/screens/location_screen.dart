import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/text_format.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  const LocationScreen(this.locationWeather, {super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  late int temp;
  late String weatherIcon;
  late String cityName;
  late String weatherMessage;
  late int feelsLike;
  late double tempMin;
  late double tempMax;
  late int humidity;
  late double windSpeed;
  late String description;

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

      double feelsLikeToint = weatherData['main']['feels_like'];
      feelsLike = feelsLikeToint.toInt();

      tempMin = weatherData['main']['temp_min'];

      tempMax = weatherData['main']['temp_max'];

      humidity = weatherData['main']['humidity'];

      windSpeed = weatherData['wind']['speed'];

      description = weatherData['weather'][0]['description'];

      // weatherMessage = weather.getMessage(temp);

      cityName = weatherData["name"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        constraints: const BoxConstraints.expand(),
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
                        width: 40,
                        color: const Color(0xFF003049),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var typedName = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CityScreen(),
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
                        width: 40,
                        color: const Color(0xFF003049),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  PoppinsText(
                    text: '$temp°',
                    fontS: 70,
                    color: const Color(0xFF003049),
                  ),
                  Lottie.asset(
                    weatherIcon,
                    width: 200,
                  ),
                  PoppinsText(
                    text: description,
                    fontS: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PoppinsText(
                            text: 'Feel\'s Like:',
                            fontS: 25,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF003049),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          PoppinsText(
                            text: feelsLike.toString() + '°',
                            fontS: 25,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PoppinsText(
                            text: 'Max: ' + tempMax.toInt().toString() + '°',
                            fontS: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("/"),
                          SizedBox(
                            width: 10,
                          ),
                          PoppinsText(
                            text: 'Min: ' + tempMin.toInt().toString() + '°',
                            fontS: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          PoppinsText(
                            text: "Humidity",
                            fontS: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'images/humidity.png',
                                width: 25,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              PoppinsText(
                                text: humidity.toString() + '%',
                                fontS: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          PoppinsText(
                            text: "Wind",
                            fontS: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'images/wind.png',
                                width: 25,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              PoppinsText(
                                text: windSpeed.toInt().toString() + ' km/h',
                                fontS: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: PoppinsText(
                          text: cityName,
                          fontS: 25,
                          textAlign: TextAlign.center,
                          color: const Color(0xFF003049),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Image.asset(
                            'images/placeholder.png',
                            width: 25,
                          ),
                        ),
                        onTap: () async {
                          var weatherData = await weather.getLocationWeather();
                          updateUI(weatherData);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
