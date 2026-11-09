import '../../models/employee.dart';
import '../services/employee_service.dart';

class EmployeeRepository {
  final EmployeeService _employeeService = EmployeeService();

  Future<List<Employee>> getEmployees({
    EmployeeStatus? status,
    EmployeeRole? role,
    String? name,
  }) async {
    return await _employeeService.findAll(
      status: status,
      role: role,
      name: name,
    );
  }

  Future<Employee> getEmployeeById(String id) async {
    return await _employeeService.findById(id);
  }

  Future<Employee> createEmployee({
    required String name,
    required String cpf,
    required String email,
    required String password,
    required List<EmployeeRole> roles,
    String? avatarUrl,
  }) async {
    return await _employeeService.create(
      name: name,
      cpf: cpf,
      email: email,
      password: password,
      roles: roles,
      avatarUrl: avatarUrl,
    );
  }

  Future<Employee> updateEmployeeStatus({
    required String id,
    required EmployeeStatus status,
  }) async {
    return await _employeeService.updateStatus(id, status);
  }

  Future<Employee> addRole({
    required String id,
    required EmployeeRole role,
  }) async {
    return await _employeeService.addRole(id, role);
  }

  Future<Employee> removeRole({
    required String id,
    required EmployeeRole role,
  }) async {
    return await _employeeService.removeRole(id, role);
  }
}