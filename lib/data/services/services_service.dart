import 'package:front_end/data/network/requester.dart';
import 'package:front_end/models/service.dart';

class ServicesService {

  final Requester _requester = Requester();

  Future<List<ServiceModel>> findAll({
    ServiceStatus? status,
    String? name,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (status != null){
      queryParameters['status'] = status.label;
    }
    if (name != null && name.isNotEmpty) {
      queryParameters['name'] = name;
    }

    final response = await _requester.get(
      '/services',
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null
    );

    if (response is List) {
      return response
      .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
      .toList();
    }
    return [];
  }

  Future<ServiceModel> findById(String id) async {
    final response = await _requester.get('/services/$id');
    return ServiceModel.fromJson(response as Map<String, dynamic>);
  }

  Future<ServiceModel> create({
    required String name,
    String? avatarUrl,
  }) async {
    final body = <String, dynamic>{
      'name': name,
    };
    if (avatarUrl != null) {
      body['avatarUrl'] = avatarUrl;
    }

    final response = await _requester.post('/services', body: body);
    return ServiceModel.fromJson(response as Map<String, dynamic>);
  }

  Future<ServiceModel> updateStatus(String id, ServiceStatus status) async {
    final body = {
      'status': status.label,
    };
    final response = await _requester.patch('/services/$id', body: body);
    return ServiceModel.fromJson(response as Map<String, dynamic>);
  }
}