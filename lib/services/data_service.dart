import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/proyecto.dart';
import '../models/visita.dart';
import '../models/vocero.dart';
import '../models/user.dart';
import '../models/planificacion.dart';
import '../models/evaluacion.dart';
import '../models/seguimiento.dart';

class DataService {
  static Future<List<Proyecto>> loadProyectos() async {
    final String response = await rootBundle.loadString('assets/data/proyectos.json');
    final data = await json.decode(response);
    return (data as List).map((json) => Proyecto.fromJson(json)).toList();
  }

  static Future<List<Visita>> loadVisitas() async {
    final String response = await rootBundle.loadString('assets/data/visitas.json');
    final data = await json.decode(response);
    return (data as List).map((json) => Visita.fromJson(json)).toList();
  }

  static Future<List<Vocero>> loadVoceros() async {
    final String response = await rootBundle.loadString('assets/data/voceros.json');
    final data = await json.decode(response);
    return (data as List).map((json) => Vocero.fromJson(json)).toList();
  }

  static Future<List<User>> loadUsers() async {
    final String response = await rootBundle.loadString('assets/data/users.json');
    final data = await json.decode(response);
    return (data as List).map((json) => User.fromJson(json)).toList();
  }

  static Future<List<Planificacion>> loadPlanificacion() async {
    final String response = await rootBundle.loadString('assets/data/planificacion.json');
    final data = await json.decode(response);
    return (data as List).map((json) => Planificacion.fromJson(json)).toList();
  }

  static Future<List<Evaluacion>> loadEvaluaciones() async {
    final String response = await rootBundle.loadString('assets/data/evaluaciones.json');
    final data = await json.decode(response);
    return (data as List).map((json) => Evaluacion.fromJson(json)).toList();
  }

  static Future<List<Seguimiento>> loadSeguimientos() async {
    final String response = await rootBundle.loadString('assets/data/seguimientos.json');
    final data = await json.decode(response);
    return (data as List).map((json) => Seguimiento.fromJson(json)).toList();
  }
}