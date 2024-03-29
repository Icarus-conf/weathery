import 'package:clima/main.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/constants.dart';
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
  // late String weatherMessage;
  late int feelsLike;
  late int tempMin;
  late int tempMax;
  late int humidity;
  late int windSpeed;
  late String description;
  late DateTime sunriseTime;
  late String sunriseTimeInHour;
  late DateTime sunsetTime;
  late String sunsetTimeInHour;

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
        // weatherMessage = 'Unable to get weather data';
        cityName = '';
        return;
      }

      double temperature = weatherData["main"]["temp"];
      temp = temperature.toInt();
      var condition = weatherData["weather"][0]["id"];
      weatherIcon = weather.getWeatherIcon(condition);

      double feelsLikeToint = weatherData['main']['feels_like'];
      feelsLike = feelsLikeToint.toInt();

      double temperatureMin = weatherData['main']['temp_min'];
      tempMin = temperatureMin.toInt();

      double temperatureMax = weatherData['main']['temp_max'];
      tempMax = temperatureMax.toInt();

      humidity = weatherData['main']['humidity'];

      double windSpeedDouble = weatherData['wind']['speed'];
      windSpeed = windSpeedDouble.toInt();

      description = weatherData['weather'][0]['description'];

      int sunrise = weatherData['sys']['sunrise'];

      sunriseTime = DateTime.fromMillisecondsSinceEpoch(sunrise * 1000);

      int sunset = weatherData['sys']['sunset'];

      sunsetTime = DateTime.fromMillisecondsSinceEpoch(sunset * 1000);

      // weatherMessage = weather.getMessage(temp);

      cityName = weatherData["name"];

      String formatTime(int hour, int minute) {
        String period = 'AM';
        if (hour >= 12) {
          period = 'PM';
          if (hour > 12) {
            hour -= 12;
          }
        }
        return '$hour:${minute.toString().padLeft(2, '0')} $period';
      }

      sunriseTimeInHour = formatTime(sunriseTime.hour, sunriseTime.minute);
      sunsetTimeInHour = formatTime(sunsetTime.hour, sunsetTime.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                        color: MyApp.themeNotifier.value == ThemeMode.light
                            ? primaryColor
                            : secondaryColor,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          MyApp.themeNotifier.value =
                              MyApp.themeNotifier.value == ThemeMode.light
                                  ? ThemeMode.dark
                                  : ThemeMode.light;
                        },
                        icon: Icon(
                          MyApp.themeNotifier.value == ThemeMode.light
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        )),
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
                        color: MyApp.themeNotifier.value == ThemeMode.light
                            ? primaryColor
                            : secondaryColor,
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
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? primaryColor
                        : secondaryColor,
                  ),
                  Lottie.asset(
                    weatherIcon,
                    width: 180,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PoppinsText(
                        text: 'Feels Like:',
                        fontS: 25,
                        fontWeight: FontWeight.w700,
                        color: MyApp.themeNotifier.value == ThemeMode.light
                            ? primaryColor
                            : secondaryColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      PoppinsText(
                        text: '$feelsLike°',
                        fontS: 25,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PoppinsText(
                        text: 'Max: ${tempMax}°',
                        fontS: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text("/"),
                      const SizedBox(
                        width: 10,
                      ),
                      PoppinsText(
                        text: 'Min: ${tempMin}°',
                        fontS: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const PoppinsText(
                        text: "Humidity",
                        fontS: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      PoppinsText(
                        text: '$humidity%',
                        fontS: 16,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'images/humidity.png',
                        width: 25,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const PoppinsText(
                        text: "Wind",
                        fontS: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      PoppinsText(
                        text: '${windSpeed} km/h',
                        fontS: 16,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'images/wind.png',
                        width: 25,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'images/sunrise.png',
                        width: 50,
                      ),
                      Column(
                        children: [
                          const PoppinsText(
                            text: 'Sunrise',
                            fontS: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          PoppinsText(
                            text: sunriseTimeInHour,
                            fontS: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'images/sunset.png',
                        width: 50,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          const PoppinsText(
                            text: 'Sunset',
                            fontS: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          PoppinsText(
                            text: sunsetTimeInHour,
                            fontS: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
                      color: MyApp.themeNotifier.value == ThemeMode.light
                          ? primaryColor
                          : secondaryColor,
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
        ),
      ),
    );
  }
}
