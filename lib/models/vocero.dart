class Vocero {
  final int id;
  final String cedula;
  final String nombre;
  final String apellido;
  final String fechaNacimiento;
  final int edad;
  final String genero;
  final String telefono;
  final String correo;
  final String direccion;
  final int idCargo;
  final String tipoVocero;

  Vocero({
    required this.id,
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.edad,
    required this.genero,
    required this.telefono,
    required this.correo,
    required this.direccion,
    required this.idCargo,
    required this.tipoVocero,
  });

  factory Vocero.fromJson(Map<String, dynamic> json) {
    return Vocero(
      id: json['id'],
      cedula: json['cedula'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      fechaNacimiento: json['fecha_nacimiento'],
      edad: json['edad'],
      genero: json['genero'],
      telefono: json['telefono'],
      correo: json['correo'],
      direccion: json['direccion'],
      idCargo: json['id_cargo'],
      tipoVocero: json['tipo_vocero'],
    );
  }
}