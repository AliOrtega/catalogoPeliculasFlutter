import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart'; // Tu pantalla de inicio
import 'screens/register_screen.dart'; // Pantalla para registrarse
import 'screens/login_screen.dart'; // Pantalla para ingresar
import 'screens/catalog_screen.dart'; // Pantalla de catálogo
import 'screens/movie_description_screen.dart'; // Pantalla de descripción de películas
import 'screens/admin_screen.dart'; // Pantalla de administración de películas

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Catalog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => const HomeScreen(),         // Pantalla principal
        '/register': (context) => const RegisterScreen(), // Pantalla de registro
        '/login': (context) => const LoginScreen(),       // Pantalla de inicio de sesión
        '/catalog': (context) => const CatalogScreen(),   // Pantalla de catálogo
        '/movieDescription': (context) => const MovieDescriptionScreen(), // Pantalla de descripción
        '/admin': (context) => const AdminScreen(),       // Pantalla de administración
      },
    );
  }
}
