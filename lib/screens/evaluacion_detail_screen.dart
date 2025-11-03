import 'package:flutter/material.dart';
import '../models/evaluacion.dart';

class EvaluacionDetailScreen extends StatelessWidget {
  final Evaluacion evaluacion;

  const EvaluacionDetailScreen({Key? key, required this.evaluacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Evaluación'),
        backgroundColor: Colors.teal[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade50,
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
                  _buildDetailItem('ID Evaluación', '#${evaluacion.id}'),
                  _buildStatusChip(evaluacion.estatus),
                ],
              ),

              // Información General
              _buildSectionTitle('Información General'),
              _buildDetailCard(
                children: [
                  _buildDetailItem('Fecha de Evaluación', _formatDate(evaluacion.fechaEvalu)),
                  _buildDetailItem('Viabilidad', evaluacion.viabilidad, isViabilidad: true),
                  _buildDetailItem('Estatus Respuesta', evaluacion.estatusResp),
                  _buildDetailItem('Proyecto ID', evaluacion.idProyecto.toString()),
                  _buildDetailItem('Responsable ID', evaluacion.idResposanble.toString()),
                ],
              ),

              // Observaciones
              _buildSectionTitle('Observaciones'),
              _buildDetailCard(
                children: [
                  Text(
                    evaluacion.observaciones,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),

              // Resumen de Evaluación
              _buildSectionTitle('Resumen de Evaluación'),
              _buildDetailCard(
                children: [
                  _buildEvaluationSummary(),
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
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      label: Text('Volver', style: TextStyle(fontSize: 16,color: Colors.white)),
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
          color: Colors.teal[800],
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

  Widget _buildDetailItem(String label, String value, {bool isViabilidad = false}) {
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
            child: isViabilidad
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getViabilidadColor(value),
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

  Widget _buildStatusChip(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(status), color: Colors.white, size: 16),
          SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryItem('Estatus', evaluacion.estatus, _getStatusColor(evaluacion.estatus)),
        _buildSummaryItem('Viabilidad', evaluacion.viabilidad, _getViabilidadColor(evaluacion.viabilidad)),
        _buildSummaryItem('Respuesta', evaluacion.estatusResp, Colors.blue),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            value.substring(0, 1),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aprobado':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'rechazado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getViabilidadColor(String viabilidad) {
    switch (viabilidad.toLowerCase()) {
      case 'alta':
        return Colors.green;
      case 'media':
        return Colors.orange;
      case 'baja':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'aprobado':
        return Icons.check_circle;
      case 'pendiente':
        return Icons.pending;
      case 'rechazado':
        return Icons.cancel;
      default:
        return Icons.help;
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