import 'package:practice_1/features/core/data/weatherapi/wapi_api.dart';
import 'package:practice_1/features/core/domain/entities/search_query.dart';
import 'package:practice_1/features/core/domain/entities/search_response.dart';
import 'package:practice_1/features/core/domain/repositories/weather_repository.dart';

class WeatherRepositoryWAPI implements WeatherRepository {
  final WApi _api;

  WeatherRepositoryWAPI(this._api);
  @override
  Future<SearchResponse> getWeather(SearchQuery query) async {
    if (query.city != null) {
      var response = await _api.getWeather(query.city!);
      return SearchResponse(response.temp.toInt(), _weatherType(response.type));
    } else {
      var response = await _api.getWeatherByCoords(query.latit!, query.langt!);
      return SearchResponse(response.temp.toInt(), _weatherType(response.type));
    }
  }
}


WeatherType _weatherType(String type) {
  switch (type) {
    case 'Sunny':
      return WeatherType.sunny;
    case 'Clouds':
      return WeatherType.cloudy;
    case 'Clear':
      return WeatherType.clear;
    case 'Rain':
      return WeatherType.rain;
    default:
      return WeatherType.other;
  }
}