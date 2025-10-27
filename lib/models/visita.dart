class Visita {
  final int id;
  final int idParroquia;
  final int idComunidad;
  final String visita;
  final String descripcionVis;

  Visita({
    required this.id,
    required this.idParroquia,
    required this.idComunidad,
    required this.visita,
    required this.descripcionVis,
  });

  factory Visita.fromJson(Map<String, dynamic> json) {
    return Visita(
      id: json['id'],
      idParroquia: json['id_parroquia'],
      idComunidad: json['id_comunidad'],
      visita: json['visita'],
      descripcionVis: json['descripcion_vis'],
    );
  }
}