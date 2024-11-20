import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.light(useMaterial3: true).copyWith(
      //scaffoldBackgroundColor: const Color(0xFFFFCDD2),
      cardTheme: const CardTheme(
        color: Color(0xFFD1C4E9), // Цвет карточки
      ),
    ),
    home: const ScaffoldExample(),
  ));
}


class ScaffoldExample extends StatelessWidget {
  const ScaffoldExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Weather App ʕ•ᴥ•ʔ'),
      ),
      body: const CityForm(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
    );
  }
}

class CityForm extends StatefulWidget {
  const CityForm({super.key});

  @override
  CityFormState createState() {
    return CityFormState();
  }
}

class CityFormState extends State<CityForm> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  String? cityName;
  Map<String, dynamic>? weatherData;

  Future<void> fetchWeather(String city) async {
    const String apiKey = '';
    final String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('City not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: _textController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'City',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final city = _textController.text;
                      setState(() {
                        cityName = city;
                      });
                      fetchWeather(city);
                      _textController.clear();
                    }
                  },
                  child: const Text('Get Weather'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (weatherData != null)
              WeatherDetails(
                cityName: weatherData!['name'],
                temperature: weatherData!['main']['temp'],
                description: weatherData!['weather'][0]['description'],
                humidity: weatherData!['main']['humidity'],
                windSpeed: weatherData!['wind']['speed'],
                iconCode: weatherData!['weather'][0]['icon'],
              )
            else if (cityName != null)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Fetching weather...',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class WeatherDetails extends StatelessWidget {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String iconCode;

  const WeatherDetails({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final iconUrl = 'https://openweathermap.org/img/wn/$iconCode@2x.png';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.network(
                      iconUrl,
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cityName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Temperature: ${temperature.toStringAsFixed(1)}°C',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Description: ${description[0].toUpperCase()}${description.substring(1)}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Humidity: $humidity%',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Wind Speed: ${windSpeed.toStringAsFixed(1)} m/s',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}