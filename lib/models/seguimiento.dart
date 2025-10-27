class Seguimiento {
  final int id;
  final int idAsignacion;
  final int idVisita;
  final String responsableSegui;
  final String fechaHor;
  final String detalleSegui;
  final double gasto;
  final String estadoActual;
  final String riesgos;

  Seguimiento({
    required this.id,
    required this.idAsignacion,
    required this.idVisita,
    required this.responsableSegui,
    required this.fechaHor,
    required this.detalleSegui,
    required this.gasto,
    required this.estadoActual,
    required this.riesgos,
  });

  factory Seguimiento.fromJson(Map<String, dynamic> json) {
    return Seguimiento(
      id: json['id'],
      idAsignacion: json['id_asignacion'],
      idVisita: json['id_visita'],
      responsableSegui: json['responsable_segui'],
      fechaHor: json['fecha_hor'],
      detalleSegui: json['detalle_segui'],
      gasto: double.parse(json['gasto'].toString()),
      estadoActual: json['estado_actual'],
      riesgos: json['riesgos'],
    );
  }
}