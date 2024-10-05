import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practice_1/features/core/data/weatherapi/models/wapi_weather.dart';

class WApi {
  final String url;
  final String apiKey;

  WApi(this.url, this.apiKey);

  Future<WAPIWeather> getWeather(String city) async{
    var response = await http.get(Uri.parse('$url/current.json?key=$apiKey&q=$city'));
    var rjson = jsonDecode(response.body);
    return WAPIWeather(rjson['current']['temp_c'], rjson['current']['condition']['text']);
  }
  Future<WAPIWeather> getWeatherByCoords(double lat, double longt) async{
    var response = await http.get(Uri.parse('$url/current.json?key=$apiKey&q=$lat,$longt'));
    var rjson = jsonDecode(response.body);
    return WAPIWeather(rjson['current']['temp_c'], rjson['current']['condition']['text']);
  }
}