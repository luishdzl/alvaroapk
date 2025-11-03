class Planificacion {
  final int id;
  final int idEvaluacion;
  final int idVocero;
  final int idComunidad;
  final int idAyuda;
  final String descriAlcance;
  final String monedaPresu;
  final double presupuesto;
  final String impactoAmbiental;
  final String impactoSocial;
  final String imagenes;
  final double latitud;
  final double longtud;
  final String direccion;
  final String fechaInicio;
  final String duracionEstimada;

  Planificacion({
    required this.id,
    required this.idEvaluacion,
    required this.idVocero,
    required this.idComunidad,
    required this.idAyuda,
    required this.descriAlcance,
    required this.monedaPresu,
    required this.presupuesto,
    required this.impactoAmbiental,
    required this.impactoSocial,
    required this.imagenes,
    required this.latitud,
    required this.longtud,
    required this.direccion,
    required this.fechaInicio,
    required this.duracionEstimada,
  });

  factory Planificacion.fromJson(Map<String, dynamic> json) {
    return Planificacion(
      id: json['id'],
      idEvaluacion: json['id_evaluacion'],
      idVocero: json['id_vocero'],
      idComunidad: json['id_comunidad'],
      idAyuda: json['id_ayuda'],
      descriAlcance: json['descri_alcance'],
      monedaPresu: json['moneda_presu'],
      presupuesto: double.parse(json['presupuesto'].toString()),
      impactoAmbiental: json['impacto_ambiental'],
      impactoSocial: json['impacto_social'],
      imagenes: json['imagenes'],
      latitud: double.parse(json['latitud'].toString()),
      longtud: double.parse(json['longtud'].toString()),
      direccion: json['direccion'],
      fechaInicio: json['fecha_inicio'],
      duracionEstimada: json['duracion_estimada'],
    );
  }
}