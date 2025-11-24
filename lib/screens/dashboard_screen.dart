import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final Function(String) onMenuSelected;

  const DashboardScreen({required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 4 : screenWidth > 800 ? 3 : 2;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final items = [
                    _DashboardItem(
                      title: 'Voceros',
                      icon: Icons.people,
                      color: Colors.blue,
                      count: '25',
                      route: '/voceros',
                    ),
                    _DashboardItem(
                      title: 'Proyectos',
                      icon: Icons.assignment,
                      color: Color(0xFFFA4242),
                      count: '23',
                      route: '/proyectos',
                    ),
                    _DashboardItem(
                      title: 'Visitas',
                      icon: Icons.visibility,
                      color: Color(0xFFFA42D2),
                      count: '31',
                      route: '/visitas',
                    ),
                    _DashboardItem(
                      title: 'Evaluaciones',
                      icon: Icons.assessment,
                      color: Color(0xFFE98AD1),
                      count: '14',
                      route: '/evaluaciones',
                    ),
                    _DashboardItem(
                      title: 'Planificaciones',
                      icon: Icons.schedule,
                      color: Color(0xFF7426F1),
                      count: '5',
                      route: '/planificacion',
                    ),
                  ];

                  final item = items[index];
                  return _LaravelStyleCard(
                    title: item.title,
                    icon: item.icon,
                    color: item.color,
                    count: item.count,
                    onTap: () {
                      onMenuSelected(item.route);
                    },
                  );
                },
                childCount: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final String count;
  final String route;

  _DashboardItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
    required this.route,
  });
}

class _LaravelStyleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String count;
  final VoidCallback onTap;

  const _LaravelStyleCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcular tamaños responsive basados en el ancho disponible
        final cardWidth = constraints.maxWidth;
        final iconSize = cardWidth * 0.2; // 20% del ancho de la tarjeta
        final titleFontSize = cardWidth * 0.09; // 9% del ancho de la tarjeta
        final countFontSize = cardWidth * 0.15; // 15% del ancho de la tarjeta
        final padding = cardWidth * 0.05; // 5% del ancho de la tarjeta

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Row(
                      children: [
                        // Icono circular responsive
                        Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                          child: Icon(
                            icon,
                            size: iconSize * 0.5, // 50% del tamaño del contenedor
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: padding),
                        // Texto y contador responsive
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: titleFontSize.clamp(12, 16), // Límites mínimo y máximo
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: padding * 0.5),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  count,
                                  style: TextStyle(
                                    fontSize: countFontSize.clamp(18, 28), // Límites mínimo y máximo
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}