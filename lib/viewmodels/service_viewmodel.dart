import 'package:flutter/foundation.dart';
import '../data/repositories/service_repository.dart';
import '../models/service.dart';

class ServiceViewModel extends ChangeNotifier {

  final ServiceRepository _repository = ServiceRepository();

  List<ServiceModel> _services = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ServiceModel> get services => _services;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadServices({
    ServiceStatus? status,
    String? name,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _services = await _repository.getServices(status: status, name: name);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createService({
    required String name,
    String? avatarUrl,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final newService = await _repository.createService(
        name: name,
        avatarUrl: avatarUrl,
      );
      _services.add(newService);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateServiceStatus({
    required String id,
    required ServiceStatus status,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updated = await _repository.updateServiceStatus(
        id: id,
        status: status,
      );
      final index = _services.indexWhere((s) => s.id == id);
      if (index != -1) {
        _services[index] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
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