import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/proyectos_screen.dart';
import 'screens/visitas_screen.dart';
import 'screens/voceros_screen.dart';
import 'screens/asignaciones_screen.dart';
import 'screens/evaluaciones_screen.dart';
import 'widgets/top_menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema Comunitario',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;

  void _handleLoginResult(bool success) {
    setState(() {
      _isLoggedIn = success;
    });
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? MainNavigation(onLogout: _logout) : LoginScreen(onLoginResult: _handleLoginResult);
  }
}

class MainNavigation extends StatefulWidget {
  final VoidCallback onLogout;

  const MainNavigation({required this.onLogout});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  String _currentRoute = '/dashboard';

  void _onMenuSelected(String route) {
    setState(() {
      _currentRoute = route;
    });
  }

  // Método corregido - siempre proporcionar onMenuSelected
  Widget _getCurrentScreen() {
    switch (_currentRoute) {
      case '/dashboard':
        return DashboardScreen(onMenuSelected: _onMenuSelected);
      case '/proyectos':
        return ProyectosScreen();
      case '/visitas':
        return VisitasScreen();
      case '/voceros':
        return VocerosScreen();
      case '/asignaciones':
        return AsignacionesScreen();
      case '/evaluaciones':
        return EvaluacionesScreen();
      default:
        return DashboardScreen(onMenuSelected: _onMenuSelected); // Corregido aquí
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopMenu(
        currentRoute: _currentRoute,
        onMenuSelected: _onMenuSelected,
        onLogout: widget.onLogout,
      ),
      body: _getCurrentScreen(),
    );
  }
}