import 'package:flutter/material.dart';
import '../models/proyecto.dart';

class ProyectoDetailScreen extends StatelessWidget {
  final Proyecto proyecto;

  const ProyectoDetailScreen({Key? key, required this.proyecto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Proyecto'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.lightBlue.shade50,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con nombre del proyecto
              _buildDetailCard(
                children: [
                  Text(
                    proyecto.nombrePro,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildPriorityChip(proyecto.prioridad),
                ],
              ),

              // Descripción del proyecto
              _buildSectionTitle('Descripción'),
              _buildDetailCard(
                children: [
                  Text(
                    proyecto.descripcionPro,
                    style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                  ),
                ],
              ),

              // Información General
              _buildSectionTitle('Información General'),
              _buildDetailCard(
                children: [
                  _buildDetailItem('Tipo de Proyecto', proyecto.tipoPro),
                  _buildDetailItem('ID Ayuda', proyecto.idAyuda.toString()),
                  _buildDetailItem('Acta de Conformidad', proyecto.actaConformidad),
                ],
              ),

              // Fechas
              _buildSectionTitle('Cronograma'),
              _buildDetailCard(
                children: [
                  _buildDateItem('Fecha Inicial', proyecto.fechaInicial),
                  _buildDateItem('Fecha Final', proyecto.fechaFinal),
                  _buildDurationItem(),
                ],
              ),

              // Actividades
              _buildSectionTitle('Actividades'),
              _buildDetailCard(
                children: [
                  Text(
                    proyecto.actividades,
                    style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                  ),
                ],
              ),

              // Resumen del Proyecto
              _buildSectionTitle('Resumen del Proyecto'),
              _buildDetailCard(
                children: [
                  _buildProjectSummary(),
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
          color: Colors.blue[800],
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

  Widget _buildDetailItem(String label, String value) {
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
            child: Text(
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

  Widget _buildDateItem(String label, String date) {
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.blue[700]),
                  SizedBox(width: 8),
                  Text(
                    _formatDate(date),
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationItem() {
    final days = _calculateDaysRemaining();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Duración:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getDurationColor(days),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    '${_calculateTotalDays()} días (${days >= 0 ? '$days días restantes' : 'Finalizado'})',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String prioridad) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getPriorityColor(prioridad),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, color: Colors.white, size: 16),
          SizedBox(width: 6),
          Text(
            'Prioridad $prioridad',
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

  Widget _buildProjectSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryItem('Prioridad', proyecto.prioridad, _getPriorityColor(proyecto.prioridad)),
        _buildSummaryItem('Tipo', proyecto.tipoPro, Colors.green),
        _buildSummaryItem('Estado', _getProjectStatus(), _getStatusColor()),
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
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getPriorityColor(String prioridad) {
    switch (prioridad.toLowerCase()) {
      case 'alta':
        return Colors.red;
      case 'media':
        return Colors.orange;
      case 'baja':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getDurationColor(int days) {
    if (days < 0) return Colors.grey;
    if (days < 30) return Colors.red;
    if (days < 90) return Colors.orange;
    return Colors.green;
  }

  Color _getStatusColor() {
    final status = _getProjectStatus();
    switch (status.toLowerCase()) {
      case 'activo':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'completado':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getProjectStatus() {
    final now = DateTime.now();
    final start = DateTime.parse(proyecto.fechaInicial);
    final end = DateTime.parse(proyecto.fechaFinal);

    if (now.isBefore(start)) return 'Pendiente';
    if (now.isAfter(end)) return 'Completado';
    return 'Activo';
  }

  int _calculateDaysRemaining() {
    final now = DateTime.now();
    final end = DateTime.parse(proyecto.fechaFinal);
    return end.difference(now).inDays;
  }

  int _calculateTotalDays() {
    final start = DateTime.parse(proyecto.fechaInicial);
    final end = DateTime.parse(proyecto.fechaFinal);
    return end.difference(start).inDays;
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