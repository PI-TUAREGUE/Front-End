import '../../models/employee.dart';
import '../network/requester.dart';

class EmployeeService {
  final Requester _requester = Requester();

  Future<List<Employee>> findAll({
    EmployeeStatus? status,
    EmployeeRole? role,
    String? name,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (status != null) queryParameters['status'] = status.label;
    if (role != null) queryParameters['role'] = role.label;
    if (name != null && name.isNotEmpty) queryParameters['name'] = name;

    final response = await _requester.get(
      '/employees',
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    if (response is List) {
      return response
          .map((item) => Employee.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Employee> findById(String id) async {
    final response = await _requester.get('/employees/$id');
    return Employee.fromJson(response as Map<String, dynamic>);
  }

  Future<Employee> create({
    required String name,
    required String cpf,
    required String email,
    required String password,
    required List<EmployeeRole> roles,
    String? avatarUrl,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'cpf': cpf,
      'email': email,
      'password': password,
      'roles': roles.map((r) => r.label).toList(),
    };
    if (avatarUrl != null) {
      body['avatarUrl'] = avatarUrl;
    }

    final response = await _requester.post('/employees', body: body);
    return Employee.fromJson(response as Map<String, dynamic>);
  }

  Future<Employee> updateStatus(String id, EmployeeStatus status) async {
    final body = {
      'status': status.label,
    };

    final response = await _requester.patch('/employees/$id/status', body: body);
    return Employee.fromJson(response as Map<String, dynamic>);
  }

  Future<Employee> addRole(String id, EmployeeRole role) async {
    final body = {
      'role': role.label,
    };
    final response = await _requester.patch('/employees/$id/roles', body: body);
    return Employee.fromJson(response as Map<String, dynamic>);
  }

  Future<Employee> removeRole(String id, EmployeeRole role) async {
    final body = {
      'roles': role.label,
    };
    final response = await _requester.delete('/employees/$id/roles', body: body);
    return Employee.fromJson(response as Map<String, dynamic>);
  }
}