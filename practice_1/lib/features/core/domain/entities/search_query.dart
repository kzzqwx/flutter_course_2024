abstract class SearchQuery {
  const SearchQuery();
}

class SearchQueryCity extends SearchQuery {
  final String city;

  SearchQueryCity(this.city);
}

class SearchQueryCoord extends SearchQuery {
  final double latit;
  final double langt;

  SearchQueryCoord(this.latit, this.langt);
}