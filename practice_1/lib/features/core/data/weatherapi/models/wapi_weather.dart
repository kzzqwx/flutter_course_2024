class WAPIWeather {
  final double temp;
  final String type;

  const WAPIWeather(this.temp, this.type);

  @override
  String toString() {
    return 'WAPIWeather{temp: $temp, type: $type}';
  }
}