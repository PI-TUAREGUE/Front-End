import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesRepository {
  
  static const String _selectedTabKey = 'selected_tab';
  
  Future<void> saveSelectedTab(int tabIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedTabKey, tabIndex);
  }
  
  Future<int> getSelectedTab() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedTabKey) ?? 0;
  }
}