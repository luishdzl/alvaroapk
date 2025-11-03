import 'package:flutter/material.dart';
import '../models/visita.dart';

class VisitaDetailScreen extends StatelessWidget {
  final Visita visita;

  const VisitaDetailScreen({Key? key, required this.visita}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Visita'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.lightGreen.shade50,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con nombre de la visita
              _buildDetailCard(
                children: [
                  Text(
                    visita.visita,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildTypeChip(visita.visita),
                ],
              ),

              // Descripción de la visita
              _buildSectionTitle('Descripción'),
              _buildDetailCard(
                children: [
                  Text(
                    visita.descripcionVis,
                    style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                  ),
                ],
              ),

              // Información de Ubicación
              _buildSectionTitle('Ubicación'),
              _buildDetailCard(
                children: [
                  _buildLocationItem('Parroquia ID', visita.idParroquia.toString()),
                  _buildLocationItem('Comunidad ID', visita.idComunidad.toString()),
                ],
              ),

              // Información Adicional
              _buildSectionTitle('Información Adicional'),
              _buildDetailCard(
                children: [
                  _buildDetailItem('ID Visita', visita.id.toString()),
                  _buildDetailItem('Tipo de Visita', _getVisitType(visita.visita)),
                ],
              ),

              // Resumen de la Visita
              _buildSectionTitle('Resumen'),
              _buildDetailCard(
                children: [
                  _buildVisitSummary(),
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
          color: Colors.green[800],
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

  Widget _buildLocationItem(String label, String value) {
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
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.green[700]),
                  SizedBox(width: 8),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.green[700],
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

  Widget _buildTypeChip(String tipoVisita) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getTypeColor(tipoVisita),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.visibility, color: Colors.white, size: 16),
          SizedBox(width: 6),
          Text(
            _getTypeText(tipoVisita),
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

  Widget _buildVisitSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryItem('Tipo', _getVisitType(visita.visita), _getTypeColor(visita.visita)),
        _buildSummaryItem('Parroquia', visita.idParroquia.toString(), Colors.blue),
        _buildSummaryItem('Comunidad', visita.idComunidad.toString(), Colors.orange),
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
            value.length > 1 ? value.substring(0, 1) : value,
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

  Color _getTypeColor(String tipoVisita) {
    if (tipoVisita.toLowerCase().contains('inspección')) {
      return Colors.orange;
    } else if (tipoVisita.toLowerCase().contains('seguimiento')) {
      return Colors.blue;
    } else if (tipoVisita.toLowerCase().contains('evaluación')) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  String _getTypeText(String tipoVisita) {
    if (tipoVisita.toLowerCase().contains('inspección')) {
      return 'Inspección';
    } else if (tipoVisita.toLowerCase().contains('seguimiento')) {
      return 'Seguimiento';
    } else if (tipoVisita.toLowerCase().contains('evaluación')) {
      return 'Evaluación';
    } else {
      return 'Visita';
    }
  }

  String _getVisitType(String visita) {
    if (visita.toLowerCase().contains('inspección')) {
      return 'Inspección Inicial';
    } else if (visita.toLowerCase().contains('seguimiento')) {
      return 'Seguimiento';
    } else if (visita.toLowerCase().contains('evaluación')) {
      return 'Evaluación Final';
    } else {
      return 'Visita General';
    }
  }
}