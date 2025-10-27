import 'package:flutter/material.dart';
import '../models/asignacion.dart';

class AsignacionDetailScreen extends StatelessWidget {
  final Asignacion asignacion;

  const AsignacionDetailScreen({Key? key, required this.asignacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Asignación'),
        backgroundColor: Colors.purple[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con ID
              _buildDetailCard(
                children: [
                  _buildDetailItem('ID Asignación', '#${asignacion.id}'),
                  _buildDetailItem('Estado', 'Activa', isStatus: true),
                ],
              ),

              // Información General
              _buildSectionTitle('Información General'),
              _buildDetailCard(
                children: [
                  _buildDetailItem('Descripción', asignacion.descriAlcance),
                  _buildDetailItem('Dirección', asignacion.direccion),
                  _buildDetailItem('Fecha Inicio', _formatDate(asignacion.fechaInicio)),
                  _buildDetailItem('Duración Estimada', asignacion.duracionEstimada),
                ],
              ),

              // Información Financiera
              _buildSectionTitle('Información Financiera'),
              _buildDetailCard(
                children: [
                  _buildDetailItem('Presupuesto', '${asignacion.monedaPresu} ${asignacion.presupuesto.toStringAsFixed(2)}'),
                  _buildDetailItem('Moneda', asignacion.monedaPresu),
                ],
              ),

              // Impactos
              _buildSectionTitle('Evaluación de Impactos'),
              _buildDetailCard(
                children: [
                  _buildImpactItem('Impacto Ambiental', asignacion.impactoAmbiental),
                  _buildImpactItem('Impacto Social', asignacion.impactoSocial),
                ],
              ),

              // Información Técnica
              _buildSectionTitle('Información Técnica'),
              _buildDetailCard(
                children: [
                  _buildDetailItem('Evaluación ID', asignacion.idEvaluacion.toString()),
                  _buildDetailItem('Vocero ID', asignacion.idVocero.toString()),
                  _buildDetailItem('Comunidad ID', asignacion.idComunidad.toString()),
                  _buildDetailItem('Ayuda ID', asignacion.idAyuda.toString()),
                  _buildDetailItem('Coordenadas', '${asignacion.latitud.toStringAsFixed(6)}, ${asignacion.longtud.toStringAsFixed(6)}'),
                ],
              ),

              // Botones de acción
              SizedBox(height: 20),
              Row(
                children: [

                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text('Volver'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.purple[800],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: isStatus
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(value),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactItem(String label, String value) {
    Color impactColor = _getImpactColor(value);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: impactColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  value,
                  style: TextStyle(
                    color: impactColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'activa':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'completada':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getImpactColor(String impact) {
    switch (impact.toLowerCase()) {
      case 'muy alto':
        return Colors.green;
      case 'alto':
        return Colors.lightGreen;
      case 'medio':
        return Colors.orange;
      case 'bajo':
        return Colors.red;
      case 'nulo':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }
}