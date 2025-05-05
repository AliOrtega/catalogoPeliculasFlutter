import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class MovieService {
  final CollectionReference moviesCollection =
      FirebaseFirestore.instance.collection('movies');

  // Crear nueva película
  Future<void> addMovie(Movie movie) async {
    await moviesCollection.doc(movie.id).set(movie.toJson());
  }

  // Eliminar película
  Future<void> deleteMovie(String id) async {
    await moviesCollection.doc(id).delete();
  }

  // Leer películas
  Stream<List<Movie>> getMovies() {
    return moviesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Movie.fromJson(doc.data() as Map<String, dynamic>)).toList();
    });
  }
}
