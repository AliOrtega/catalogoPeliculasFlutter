class Movie {
  final String id; // ID único de la película
  final String title;
  final String year;
  final String director;
  final String genre;
  final String synopsis;
  final String imageUrl;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.director,
    required this.genre,
    required this.synopsis,
    required this.imageUrl,
  });

  // Método para convertir el modelo a JSON para Firebase
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'year': year,
        'director': director,
        'genre': genre,
        'synopsis': synopsis,
        'imageUrl': imageUrl,
      };

  // Método para crear un modelo desde un JSON (ej. al leer de Firebase)
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      year: json['year'],
      director: json['director'],
      genre: json['genre'],
      synopsis: json['synopsis'],
      imageUrl: json['imageUrl'],
    );
  }
}
