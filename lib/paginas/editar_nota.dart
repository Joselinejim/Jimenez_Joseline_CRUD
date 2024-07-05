import 'package:flutter/material.dart';
import 'package:crud_flutter_joseline/db/operaciones.dart';
import 'package:crud_flutter_joseline/modelo/notas.dart';

class EditNoteScreen extends StatefulWidget {
  final Nota nota;

  EditNoteScreen({required this.nota});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.nota.titulo);
    _descriptionController = TextEditingController(text: widget.nota.description);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Nota'),
        backgroundColor: Colors.pink.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese un título';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Título de la nota',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 80, 0, 150)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(209, 0, 95, 150)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLength: 1000,
                maxLines: 4,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Descripción de la Nota',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 150, 0, 0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 150, 0, 37)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      child: Text('Actualizar nota'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            
                            final updatedNota = Nota(
                              id: widget.nota.id,
                              titulo: _tituloController.text,
                              description: _descriptionController.text,
                            );

                            
                            await Operaciones.actualizarOperacion(updatedNota);

                            setState(() {
                              _isLoading = false;
                            });

                            
                            Navigator.pop(context, true); 
                          } catch (e) {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al actualizar la nota: $e')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 249, 173, 173),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}