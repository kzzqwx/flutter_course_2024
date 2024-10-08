import 'package:practice_1/features/core/data/debug/weather_repository_debug.dart';
import 'package:practice_1/features/core/data/osm/osm_api.dart';
import 'package:practice_1/features/core/data/osm/weather_repository_osm.dart';
import 'package:practice_1/features/core/data/weatherapi/wapi_api.dart';
import 'package:practice_1/features/core/data/weatherapi/weather_repository_wapi.dart';
import 'package:practice_1/features/core/presentation/app.dart';

const String version = '0.0.1';
const String url_osm = 'https://api.openweathermap.org';
const String urla_wapi = 'http://api.weatherapi.com/v1';
const String apiKey = 'key';

void main(List<String> arguments) {
  var app = App(WeatherRepositoryWAPI(WApi(urla_wapi, apiKey)));

  app.run();
}
