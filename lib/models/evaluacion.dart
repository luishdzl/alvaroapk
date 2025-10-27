class Evaluacion {
  final int id;
  final int idProyecto;
  final String fechaEvalu;
  final int idResposanble;
  final String observaciones;
  final String estatus;
  final String estatusResp;
  final String viabilidad;

  Evaluacion({
    required this.id,
    required this.idProyecto,
    required this.fechaEvalu,
    required this.idResposanble,
    required this.observaciones,
    required this.estatus,
    required this.estatusResp,
    required this.viabilidad,
  });

  factory Evaluacion.fromJson(Map<String, dynamic> json) {
    return Evaluacion(
      id: json['id'],
      idProyecto: json['id_proyecto'],
      fechaEvalu: json['fecha_evalu'],
      idResposanble: json['id_resposanble'],
      observaciones: json['observaciones'],
      estatus: json['estatus'],
      estatusResp: json['estatus_resp'],
      viabilidad: json['viabilidad'],
    );
  }
}