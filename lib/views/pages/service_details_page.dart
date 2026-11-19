import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../models/service.dart';
import '../widgets/services/service_details_header.dart';
import '../widgets/services/service_general_info_card.dart';
import '../widgets/services/service_status_modal.dart';

class ServiceDetailsPage extends StatefulWidget {
  final ServiceModel service;

  const ServiceDetailsPage({
    super.key,
    required this.service,
  });

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  final ServiceRepository _serviceRepository = ServiceRepository();
  final AuthRepository _authRepository = AuthRepository();

  late ServiceModel _service;
  bool _isAdmin = false;
  bool _isUpdatingStatus = false;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _service = widget.service;
    _checkAdminRole();
    _fetchFreshService();
  }

  Future<void> _checkAdminRole() async {
    final isAdmin = await _authRepository.isCurrentUserAdmin();
    if (mounted) {
      setState(() => _isAdmin = isAdmin);
    }
  }

  Future<void> _fetchFreshService() async {
    try {
      final fresh = await _serviceRepository.getServiceById(widget.service.id);
      if (mounted) {
        setState(() => _service = fresh);
      }
    } catch (_) {}
  }

  Future<void> _onStatusTap() async {
    if (!_isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Apenas administradores podem alterar o status do serviço.'),
          backgroundColor: Color(0xFFFF7A00),
        ),
      );
      return;
    }

    if (_isUpdatingStatus) return;

    final newStatus = await ServiceStatusModal.show(context, _service.status);
    if (newStatus == null || newStatus == _service.status || !mounted) {
      return;
    }

    setState(() => _isUpdatingStatus = true);

    try {
      final updated = await _serviceRepository.updateServiceStatus(
        id: _service.id,
        status: newStatus,
      );
      if (!mounted) return;
      setState(() {
        _service = updated;
        _hasChanged = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status do serviço atualizado com sucesso.'),
          backgroundColor: Color(0xFF28A745),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar status: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdatingStatus = false);
      }
    }
  }

  void _handleBack() {
    Navigator.of(context).pop(_hasChanged);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ServiceDetailsHeader(
                onBack: _handleBack,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações gerais:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ServiceGeneralInfoCard(
                      service: _service,
                      isAdmin: _isAdmin,
                      isUpdatingStatus: _isUpdatingStatus,
                      onStatusTap: _onStatusTap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
