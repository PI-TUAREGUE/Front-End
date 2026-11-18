import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../models/employee.dart';
import '../../viewmodels/employee_viewmodel.dart';
import '../widgets/cards/employee_card.dart';
import '../widgets/employees/create_employee_modal.dart';
import '../widgets/shared/empty_state_widget.dart';
import '../widgets/shared/filter_dropdown.dart';
import '../widgets/shared/primary_add_button.dart';
import '../widgets/shared/timeline_group.dart';
import 'employee_details_page.dart';

enum EmployeeFilterOption {
  date('Data'),
  name('Nome (A-Z)'),
  active('Ativos'),
  inactive('Inativos'),
  mechanic('Mecânicos'),
  admin('Administradores');

  final String label;
  const EmployeeFilterOption(this.label);
}

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  late final EmployeeViewModel _viewModel;
  EmployeeFilterOption _selectedFilter = EmployeeFilterOption.date;
  bool _isAdmin = false;
  bool _isLoadingRole = true;

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
    _viewModel = EmployeeViewModel();
    _checkAdminRole();
  }

  Future<void> _checkAdminRole() async {
    final isAdmin = await AuthRepository().isCurrentUserAdmin();
    if (!mounted) return;
    setState(() {
      _isAdmin = isAdmin;
      _isLoadingRole = false;
    });
    if (isAdmin) {
      _viewModel.loadEmployees();
    }
  }

  void _openCreateEmployeeModal() {
    if (!_isAdmin) return;
    CreateEmployeeModal.show(
      context: context,
      employeeViewModel: _viewModel,
      onEmployeeCreated: () {
        _viewModel.loadEmployees();
      },
    );
  }

  Map<String, List<Employee>> _groupEmployeesByMonth(List<Employee> list) {
    final filtered = list.where((e) {
      switch (_selectedFilter) {
        case EmployeeFilterOption.active:
          return e.status == EmployeeStatus.active;
        case EmployeeFilterOption.inactive:
          return e.status == EmployeeStatus.inactive;
        case EmployeeFilterOption.mechanic:
          return e.roles.contains(EmployeeRole.mechanic);
        case EmployeeFilterOption.admin:
          return e.roles.contains(EmployeeRole.admin);
        case EmployeeFilterOption.date:
        case EmployeeFilterOption.name:
          return true;
      }
    }).toList();

    filtered.sort((a, b) {
      if (_selectedFilter == EmployeeFilterOption.name) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
      final dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA);
    });

    final Map<String, List<Employee>> grouped = {};

    for (final employee in filtered) {
      final date = employee.createdAt?.toLocal() ?? DateTime.now();
      final monthName = _monthNames[date.month - 1];
      final key = '$monthName, ${date.year}';

      grouped.putIfAbsent(key, () => []).add(employee);
    }

    return grouped;
  }

  Widget _buildBlockedAccess() {
    return RefreshIndicator(
      color: const Color(0xFFFF7A00),
      backgroundColor: const Color(0xFF141416),
      onRefresh: _checkAdminRole,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Lista de Colaboradores',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 80),
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E22),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFF7A00),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.lock_person_outlined,
                  color: Color(0xFFFF7A00),
                  size: 44,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Acesso Restrito',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Esta tela é exclusiva para administradores da oficina.\n\nSeu perfil não possui permissão para visualizar colaboradores.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: _isLoadingRole
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF7A00),
                ),
              )
            : !_isAdmin
                ? _buildBlockedAccess()
                : RefreshIndicator(
          color: const Color(0xFFFF7A00),
          backgroundColor: const Color(0xFF141416),
          onRefresh: () => _viewModel.loadEmployees(),
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              final grouped = _groupEmployeesByMonth(_viewModel.employees);
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
                        'Lista de Colaboradores',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilterDropdown<EmployeeFilterOption>(
                      selectedValue: _selectedFilter,
                      options: EmployeeFilterOption.values
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
                        label: 'Novo Colaborador',
                        onTap: _openCreateEmployeeModal,
                      ),
                      const SizedBox(height: 24),
                    ] else ...[
                      const SizedBox(height: 12),
                    ],
                    if (_viewModel.isLoading && _viewModel.employees.isEmpty) ...[
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
                        icon: Icons.people_outline,
                        message: 'Nenhum colaborador encontrado',
                      ),
                    ] else ...[
                      for (int i = 0; i < groupKeys.length; i++) ...[
                        TimelineGroup(
                          title: groupKeys[i],
                          children: grouped[groupKeys[i]]!
                              .map(
                                (employee) => EmployeeCard(
                                  employee: employee,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => EmployeeDetailsPage(
                                          employee: employee,
                                          viewModel: _viewModel,
                                        ),
                                      ),
                                    );
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
