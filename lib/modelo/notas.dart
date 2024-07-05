class Nota{
  final int? id;
  final String titulo;
  final String description;

  Nota({ this.id, required this.titulo, required this.description });

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'titulo' : titulo,
      'description' : description,
    };
  }
}