import 'package:flutter/material.dart';
import '../../../models/employee.dart';

class TeamAvatarStack extends StatelessWidget {
  final List<Employee> employees;
  final int maxVisible;

  const TeamAvatarStack({
    super.key,
    required this.employees,
    this.maxVisible = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) return const SizedBox.shrink();

    final visibleCount = employees.length > maxVisible ? maxVisible : employees.length;
    final remainingCount = employees.length - maxVisible;
    final stackWidth = 24.0 + (visibleCount - 1) * 14.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: stackWidth,
          height: 24,
          child: Stack(
            children: [
              for (int i = 0; i < visibleCount; i++)
                Positioned(
                  left: i * 14.0,
                  child: _buildAvatar(employees[i]),
                ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        if (remainingCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '+$remainingCount',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatar(Employee employee) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF28282B), width: 2),
      ),
      child: ClipOval(
        child: employee.avatarUrl != null
            ? Image.network(
                employee.avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildFallbackIcon(),
              )
            : _buildFallbackIcon(),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: const Color(0xFF3E3E42),
      child: const Icon(Icons.person, size: 14, color: Colors.white70),
    );
  }
}