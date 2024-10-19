import 'package:practice_1/features/core/data/osm/osm_api.dart';
import 'package:practice_1/features/core/data/weatherapi/wapi_api.dart';
import 'package:practice_1/features/core/data/weatherapi/weather_repository_wapi.dart';
import 'package:practice_1/features/core/presentation/app.dart';
import 'package:practice_1/features/core/data/osm/weather_repository_osm.dart';

const String version = '0.0.1';
const String url_osm = 'https://api.openweathermap.org';
const String url_wapi = 'http://api.weatherapi.com/v1';
const String apiKey = 'key';

void main(List<String> arguments) {
  var app = App(WeatherRepositoryOSM(OSMApi(url_osm, apiKey)));

  app.run();
}
