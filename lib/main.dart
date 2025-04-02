import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Bienvenido a mi app de películas';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(appTitle)),
        body: Stack(
          children: [
            // Imagen de fondo
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.pexels.com/photos/3709369/pexels-photo-3709369.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Contenido centrado
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centrado vertical
                crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal
                children: [
                  const SizedBox(height: 16), // Espaciado inicial
                  const TitleSection(
                    name: 'Catálogo de películas',
                    location: 'Animadas',
                  ),
                  const TitleSection(
                    name: 'Descripción',
                    location:
                        'En esta aplicación podrás ver una lista de películas animadas.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.name, required this.location});

  final String name;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                  textAlign: TextAlign.center, // Alinea el texto al centro
                ),
              ),
            ),
            Text(
              location,
              textAlign: TextAlign.center, // Alinea el texto al centro
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Text(
          description,
          textAlign: TextAlign.center, 
          softWrap: true,
        ),
      ),
    );
  }
}
