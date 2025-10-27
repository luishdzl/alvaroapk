class Proyecto {
  final int id;
  final String nombrePro;
  final String descripcionPro;
  final String tipoPro;
  final int idAyuda;
  final String actividades;
  final String fechaInicial;
  final String fechaFinal;
  final String prioridad;
  final String actaConformidad;

  Proyecto({
    required this.id,
    required this.nombrePro,
    required this.descripcionPro,
    required this.tipoPro,
    required this.idAyuda,
    required this.actividades,
    required this.fechaInicial,
    required this.fechaFinal,
    required this.prioridad,
    required this.actaConformidad,
  });

  factory Proyecto.fromJson(Map<String, dynamic> json) {
    return Proyecto(
      id: json['id'],
      nombrePro: json['nombre_pro'],
      descripcionPro: json['descripcion_pro'],
      tipoPro: json['tipo_pro'],
      idAyuda: json['id_ayuda'],
      actividades: json['actividades'],
      fechaInicial: json['fecha_inicial'],
      fechaFinal: json['fecha_final'],
      prioridad: json['prioridad'],
      actaConformidad: json['acta_conformidad'],
    );
  }
}