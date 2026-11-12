import 'package:flutter/foundation.dart';
import '../data/repositories/employee_repository.dart';
import '../models/employee.dart';

class EmployeeViewModel extends ChangeNotifier {
  final EmployeeRepository _repository = EmployeeRepository();

  List<Employee> _employees = [];
  Employee? _selectedEmployee;
  bool _isLoading = false;
  String? _errorMessage;

  List<Employee> get employees => _employees;
  Employee? get selectedEmployee => _selectedEmployee;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadEmployees({
    EmployeeStatus? status,
    EmployeeRole? role,
    String? name,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _employees = await _repository.getEmployees(
        status: status,
        role: role,
        name: name,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadEmployeeById(String id) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedEmployee = await _repository.getEmployeeById(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createEmployee({
    required String name,
    required String cpf,
    required String email,
    required String password,
    required List<EmployeeRole> roles,
    String? avatarUrl,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final created = await _repository.createEmployee(
        name: name,
        cpf: cpf,
        email: email,
        password: password,
        roles: roles,
        avatarUrl: avatarUrl,
      );
      _employees.add(created);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateEmployeeStatus({
    required String id,
    required EmployeeStatus status,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updated = await _repository.updateEmployeeStatus(
        id: id,
        status: status,
      );
      _replaceEmployee(updated);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addRole({
    required String id,
    required EmployeeRole role,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updated = await _repository.addRole(id: id, role: role);
      _replaceEmployee(updated);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> removeRole({
    required String id,
    required EmployeeRole role,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updated = await _repository.removeRole(id: id, role: role);
      _replaceEmployee(updated);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _replaceEmployee(Employee updated) {
    final index = _employees.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _employees[index] = updated;
    }
    if (_selectedEmployee?.id == updated.id) {
      _selectedEmployee = updated;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}