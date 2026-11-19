import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../models/service.dart';
import '../../viewmodels/service_viewmodel.dart';
import '../widgets/cards/service_card.dart';
import '../widgets/services/create_service_modal.dart';
import '../widgets/shared/empty_state_widget.dart';
import '../widgets/shared/filter_dropdown.dart';
import '../widgets/shared/primary_add_button.dart';
import '../widgets/shared/timeline_group.dart';
import 'service_details_page.dart';

enum ServiceFilterOption {
  date('Data'),
  name('Nome (A-Z)'),
  active('Ativos'),
  inactive('Inativos');

  final String label;
  const ServiceFilterOption(this.label);
}

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late final ServiceViewModel _viewModel;
  ServiceFilterOption _selectedFilter = ServiceFilterOption.date;
  bool _isAdmin = false;

  static const List<String> _monthNames = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = ServiceViewModel();
    _viewModel.loadServices();
    _checkAdminRole();
  }

  Future<void> _checkAdminRole() async {
    final isAdmin = await AuthRepository().isCurrentUserAdmin();
    if (mounted) {
      setState(() => _isAdmin = isAdmin);
    }
  }

  void _openCreateServiceModal() {
    if (!_isAdmin) return;
    CreateServiceModal.show(
      context: context,
      serviceViewModel: _viewModel,
      onServiceCreated: () {
        _viewModel.loadServices();
      },
    );
  }

  Map<String, List<ServiceModel>> _groupServicesByMonth(
      List<ServiceModel> list) {
    final filtered = list.where((s) {
      switch (_selectedFilter) {
        case ServiceFilterOption.active:
          return s.status == ServiceStatus.active;
        case ServiceFilterOption.inactive:
          return s.status == ServiceStatus.inactive;
        case ServiceFilterOption.date:
        case ServiceFilterOption.name:
          return true;
      }
    }).toList();

    filtered.sort((a, b) {
      if (_selectedFilter == ServiceFilterOption.name) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
      final dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA);
    });

    final Map<String, List<ServiceModel>> grouped = {};

    for (final service in filtered) {
      final date = service.createdAt?.toLocal() ?? DateTime.now();
      final monthName = _monthNames[date.month - 1];
      final key = '$monthName, ${date.year}';

      grouped.putIfAbsent(key, () => []).add(service);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFFF7A00),
          backgroundColor: const Color(0xFF141416),
          onRefresh: () => _viewModel.loadServices(),
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              final grouped = _groupServicesByMonth(_viewModel.services);
              final groupKeys = grouped.keys.toList();

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Lista de Serviços',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilterDropdown<ServiceFilterOption>(
                      selectedValue: _selectedFilter,
                      options: ServiceFilterOption.values
                          .map((o) => FilterDropdownOption(
                                value: o,
                                label: o.label,
                              ))
                          .toList(),
                      onSelected: (option) {
                        setState(() => _selectedFilter = option);
                      },
                    ),
                    const SizedBox(height: 18),
                    if (_isAdmin) ...[
                      PrimaryAddButton(
                        label: 'Novo Serviço',
                        onTap: _openCreateServiceModal,
                      ),
                      const SizedBox(height: 24),
                    ] else ...[
                      const SizedBox(height: 12),
                    ],
                    if (_viewModel.isLoading && _viewModel.services.isEmpty) ...[
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF7A00),
                          ),
                        ),
                      ),
                    ] else if (groupKeys.isEmpty) ...[
                      const EmptyStateWidget(
                        icon: Icons.build_circle_outlined,
                        message: 'Nenhum serviço encontrado',
                      ),
                    ] else ...[
                      for (int i = 0; i < groupKeys.length; i++) ...[
                        TimelineGroup(
                          title: groupKeys[i],
                          children: grouped[groupKeys[i]]!
                              .map(
                                (service) => ServiceCard(
                                  service: service,
                                  onTap: () async {
                                    final changed =
                                        await Navigator.of(context).push<bool>(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ServiceDetailsPage(service: service),
                                      ),
                                    );
                                    if (changed == true) {
                                      _viewModel.loadServices();
                                    }
                                  },
                                ),
                              )
                              .toList(),
                        ),
                        if (i < groupKeys.length - 1)
                          const SizedBox(height: 20),
                      ],
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
