import 'package:flutter/material.dart';
import 'package:crud_flutter_joseline/db/operaciones.dart';
import 'package:crud_flutter_joseline/modelo/notas.dart';
import 'package:crud_flutter_joseline/paginas/editar_nota.dart';
import 'package:crud_flutter_joseline/paginas/guardarPagina.dart';

class ListPages extends StatefulWidget {
  const ListPages({Key? key}) : super(key: key);

  @override
  State<ListPages> createState() => _ListPagesState();
}

class _ListPagesState extends State<ListPages> {
  List<Nota> notas = [];

  @override
  void initState() {
    _cargarDatos();
    Operaciones.setOnDatabaseChange(
        _onDatabaseChange); 
    super.initState();
  }

  void _onDatabaseChange() {
    _cargarDatos(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => guardarPagina()),
          );
          if (result == true) {
            _cargarDatos(); 
          }
        },
      ),
      appBar: AppBar(
        title: const Text('CRUD JOSELINE'),
        backgroundColor: Colors.red.shade200,
      ),
      body: Container(child: _buildListaNotas()),
    );
  }

  Widget _buildListaNotas() {
    return FutureBuilder<List<Nota>>(
      future: Operaciones.obtenerNotas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay notas disponibles'));
        } else {
          notas = snapshot.data!;
          return ListView.builder(
            itemCount: notas.length,
            itemBuilder: (_, index) {
              return _buildItemNota(context, index);
            },
          );
        }
      },
    );
  }

  Widget _buildItemNota(BuildContext context, int index) {
    Nota nota = notas[index];
    return Dismissible(
      key: Key(nota.id.toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: const EdgeInsets.only(left: 20),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete, color: Colors.white, size: 30),
        ),
      ),
      onDismissed: (direction) {
        // Eliminar nota
        Operaciones.eliminarOperacion(nota);
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          leading: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            child: Icon(
              Icons.laptop_windows_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Text(
            nota.titulo,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          trailing: Icon(Icons.edit, color: Colors.black),
          onTap: () async {
            bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditNoteScreen(nota: nota),
              ),
            );
            if (result == true) {
              _cargarDatos(); 
            }
          },
        ),
      ),
    );
  }

  _cargarDatos() async {
    List<Nota> auxNotas = await Operaciones.obtenerNotas();
    setState(() {
      notas = auxNotas;
    });
  }
}