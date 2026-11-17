import 'package:flutter/material.dart';
import '../../../models/employee.dart';
import '../../../viewmodels/employee_viewmodel.dart';

class CreateEmployeeModal extends StatefulWidget {
  final EmployeeViewModel employeeViewModel;
  final VoidCallback onEmployeeCreated;

  const CreateEmployeeModal({
    super.key,
    required this.employeeViewModel,
    required this.onEmployeeCreated,
  });

  static Future<void> show({
    required BuildContext context,
    required EmployeeViewModel employeeViewModel,
    required VoidCallback onEmployeeCreated,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateEmployeeModal(
        employeeViewModel: employeeViewModel,
        onEmployeeCreated: onEmployeeCreated,
      ),
    );
  }

  @override
  State<CreateEmployeeModal> createState() => _CreateEmployeeModalState();
}

class _CreateEmployeeModalState extends State<CreateEmployeeModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final Set<EmployeeRole> _selectedRoles = {EmployeeRole.mechanic};
  bool _isLoading = false;
  String? _localError;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRoles.isEmpty) {
      setState(() => _localError = 'Selecione ao menos um cargo.');
      return;
    }

    setState(() {
      _isLoading = true;
      _localError = null;
    });

    final success = await widget.employeeViewModel.createEmployee(
      name: _nameController.text.trim(),
      cpf: _cpfController.text.replaceAll(RegExp(r'\D'), ''),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      roles: _selectedRoles.toList(),
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      widget.onEmployeeCreated();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF28A745),
          content: Text('Colaborador cadastrado com sucesso!'),
        ),
      );
    } else if (mounted) {
      setState(() {
        _localError = widget.employeeViewModel.errorMessage ??
            'Não foi possível cadastrar o colaborador.';
      });
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white30),
      filled: true,
      fillColor: const Color(0xFF28282B),
      prefixIcon: Icon(icon, color: const Color(0xFFFF7A00)),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF7A00)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF141416),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Novo Colaborador',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  label: 'Nome completo',
                  hint: 'Ex: Wendel Bezerra',
                  icon: Icons.person_outline,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Informe o nome';
                  }
                  if (val.trim().length < 3) {
                    return 'Mínimo de 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  label: 'CPF',
                  hint: 'Ex: 000.000.000-00',
                  icon: Icons.tag,
                ),
                validator: (val) {
                  final clean = (val ?? '').replaceAll(RegExp(r'\D'), '');
                  if (clean.length != 11) {
                    return 'CPF deve conter 11 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  label: 'E-mail (@tuaregue.com)',
                  hint: 'Ex: wendel@tuaregue.com',
                  icon: Icons.email_outlined,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Informe o e-mail';
                  }
                  if (!val.trim().endsWith('@tuaregue.com')) {
                    return 'O e-mail deve terminar com @tuaregue.com';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  label: 'Senha de acesso',
                  hint: 'Mínimo de 8 caracteres',
                  icon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Informe a senha';
                  }
                  if (val.length < 8) {
                    return 'A senha deve conter no mínimo 8 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Cargos / Funções',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: EmployeeRole.values.map((role) {
                  final isSelected = _selectedRoles.contains(role);
                  return ChoiceChip(
                    label: Text(
                      role.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFF7A00),
                    backgroundColor: const Color(0xFF28282B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFFFF7A00)
                            : Colors.white24,
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedRoles.add(role);
                        } else if (_selectedRoles.length > 1) {
                          _selectedRoles.remove(role);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              if (_localError != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF381E1E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFFF5252),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFFFF5252),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _localError!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A00),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Cadastrar Colaborador',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
