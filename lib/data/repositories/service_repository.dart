import '../../models/service.dart';
import '../services/service_service.dart';

class ServiceRepository {
  final ServiceService _serviceService = ServiceService();

  Future<List<ServiceModel>> getServices({
    ServiceStatus? status,
    String? name,
  }) async {
    return await _serviceService.findAll(status: status, name: name);
  }

  Future<ServiceModel> getServiceById(String id) async {
    return await _serviceService.findById(id);
  }

  Future<ServiceModel> createService({
    required String name,
    String? avatarUrl,
  }) async {
    return await _serviceService.create(name: name, avatarUrl: avatarUrl);
  }

  Future<ServiceModel> updateServiceStatus({
    required String id,
    required ServiceStatus status,
  }) async {
    return await _serviceService.updateStatus(id, status);
  }
}