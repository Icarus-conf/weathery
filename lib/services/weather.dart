import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

const apiKey = '1c06386a9ec3973be023871821932020';
const openWeatherURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    var url = '$openWeatherURL?q=$cityName&appid=$apiKey&units=metric';
    NetworkHelper networkHelper = NetworkHelper(url);
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');

    var weatherData = await networkHelper.getData();

    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return 'images/thunder.json';
    } else if (condition < 400) {
      return 'images/rainy.json';
    } else if (condition < 600) {
      return 'images/rainy.json';
    } else if (condition < 700) {
      return 'images/snowy.json';
    } else if (condition < 800) {
      return 'images/storm.json';
    } else if (condition == 800) {
      return 'images/sunny.json';
    } else if (condition <= 804) {
      return 'images/cloudy.json';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
