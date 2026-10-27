import 'package:flutter/material.dart';
import '../../models/data/repository/appointment_repository.dart';
import 'agenda_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  final AppointmentRepository _repository = AppointmentRepository();
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    AgendaPage(),
    Center(
      child: Text(
        'Lista de Serviços',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
    Center(
      child: Text(
        'Lista de Colaboradores',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
    Center(
      child: Text(
        'Meu Perfil',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedTab();
  }

  Future<void> _loadSavedTab() async {
    final savedTab = await _repository.getSelectedTab();
    if (!mounted) return;
    setState(() {
      _currentIndex = savedTab;
    });
  }

  Future<void> _onTabTapped(int index) async {
    setState(() {
      _currentIndex = index;
    });
    await _repository.saveSelectedTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF141416),
        selectedItemColor: const Color(0xFFE58E1A),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            label: 'Serviços',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Colaboradores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.badge_outlined),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
