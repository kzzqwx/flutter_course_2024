class SearchQuery {
  final String? city;
  final double? latit;
  final double? langt;

  const SearchQuery.byCity(this.city) : latit = null, langt = null;
  const SearchQuery.byCoords(this.latit, this.langt) : city = null;
}