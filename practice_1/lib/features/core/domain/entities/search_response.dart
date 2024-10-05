class SearchResponse {
  final int temp;
  final WeatherType type;

  const SearchResponse(this.temp, this.type);

  @override
  String toString() {
    return 'SearchResponse{temp: $temp, type: $type}';
  }
}

enum WeatherType {sunny, clear, rain, cloudy, other}