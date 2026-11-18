import 'package:flutter/material.dart';
import '../../../models/employee.dart';

class AppointmentCollaboratorsSection extends StatelessWidget {
  final List<Employee> employees;

  const AppointmentCollaboratorsSection({
    super.key,
    required this.employees,
  });

  Widget _buildCollaboratorFallback() {
    return Container(
      color: const Color(0xFF1E1E22),
      child: const Icon(
        Icons.person,
        size: 38,
        color: Color(0xFFFF7A00),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Flexible(
              child: Text(
                'Colaboradores:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.people_outline,
                  size: 15,
                  color: Colors.white54,
                ),
                const SizedBox(width: 4),
                Text(
                  '${employees.length} ${employees.length == 1 ? "Colaborador" : "Colaboradores"}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (employees.isEmpty) ...[
          const Text(
            'Nenhum colaborador atribuído.',
            style: TextStyle(color: Colors.white54),
          ),
        ] else ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: employees.map((emp) {
                return Container(
                  margin: const EdgeInsets.only(right: 18),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF28282B),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: emp.avatarUrl != null &&
                                  emp.avatarUrl!.isNotEmpty
                              ? Image.network(
                                  emp.avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          _buildCollaboratorFallback(),
                                )
                              : _buildCollaboratorFallback(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 78,
                        child: Text(
                          emp.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
