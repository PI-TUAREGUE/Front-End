import '../../models/service.dart';
import '../services/services_service.dart';

class ServicesRepository {
  final ServicesService _servicesService = ServicesService();

  Future<List<ServiceModel>> getServices({
    ServiceStatus? status,
    String? name,
  }) async {
    return await _servicesService.findAll(status: status, name: name);
  }

  Future<ServiceModel> getServiceById(String id) async {
    return await _servicesService.findById(id);
  }

  Future<ServiceModel> createService({
    required String name,
    String? avatarUrl,
  }) async {
    return await _servicesService.create(name: name, avatarUrl: avatarUrl);
  }

  Future<ServiceModel> updateServiceStatus({
    required String id,
    required ServiceStatus status,
  }) async {
    return await _servicesService.updateStatus(id, status);
  }
}