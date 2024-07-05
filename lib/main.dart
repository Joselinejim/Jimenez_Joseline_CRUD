import 'package:flutter/material.dart';
import 'package:crud_flutter_joseline/paginas/pagina_lista.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas de tareas',
      debugShowCheckedModeBanner: false,
      home: ListPages(),
    );
  }
}