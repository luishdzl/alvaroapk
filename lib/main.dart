import 'package:flutter/material.dart';
import 'auth_service.dart'; // Asegúrate de importar el servicio
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/proyectos_screen.dart';
import 'screens/visitas_screen.dart';
import 'screens/voceros_screen.dart';
import 'screens/planificacion_screen.dart';
import 'screens/evaluaciones_screen.dart';
import 'widgets/top_menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGISSAF',
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  void _handleLoginResult(bool success) async {
    if (success) {
      await AuthService.setLoggedIn(true);
    }
    setState(() {
      _isLoggedIn = success;
    });
  }

void _logout() async {
  await AuthService.logout(); // Limpiar la sesión
  setState(() {
    _isLoggedIn = false;
  });
} 

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
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
      case '/planificacion':
        return PlanificacionScreen();
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