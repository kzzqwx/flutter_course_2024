import 'package:practice_1/features/core/domain/entities/search_query.dart';
import 'package:practice_1/features/core/domain/entities/search_response.dart';
import 'package:practice_1/features/core/domain/repositories/weather_repository.dart';
import 'dart:io';


class App {
  final WeatherRepository repository;

  App(this.repository);

  void run() async {
    print('Введите 1, если хотите найти погоду по городу, или 2, если по координатам:');
    var choice = stdin.readLineSync();

    if (choice == null || (choice != '1' && choice != '2')) {
      print('Неверный выбор');
      return;
    }

    SearchQuery query;
    if (choice == '1') {
      print('Введите город:');
      var city = stdin.readLineSync();
      if (city == null || city.isEmpty) {
        print('Ошибка ввода города');
        return;
      }
      query = SearchQuery.byCity(city);
    } else {
      print('Введите координаты (широта, долгота):');
      var input = stdin.readLineSync();
      if (input == null) {
        print('Ошибка ввода');
        return;
      }

      var coords = input.split(',');
      if (coords.length != 2) {
        print('Неверный формат координат');
        return;
      }
      var latitude = double.tryParse(coords[0].trim());
      var longitude = double.tryParse(coords[1].trim());
      if (latitude == null || longitude == null) {
        print('Неверный формат координат');
        return;
      }
      query = SearchQuery.byCoords(latitude, longitude);
    }

    var resp = await repository.getWeather(query);
    print('Погода в этой локации: ${resp.temp} по Цельсию, тип: ${weatherTypeToString(resp.type)}');
  }
}

String weatherTypeToString(WeatherType type) {
  switch (type) {
    case WeatherType.cloudy:
      return 'Clouds';
    case WeatherType.clear:
      return 'Clear';
    case WeatherType.rain:
      return 'Rain';
    case WeatherType.sunny:
      return 'Sunny';
    default:
      return 'Other';
  }
}