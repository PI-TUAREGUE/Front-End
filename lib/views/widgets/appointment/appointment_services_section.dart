import 'package:flutter/material.dart';
import '../../../models/service.dart';

class AppointmentServicesSection extends StatelessWidget {
  final List<ServiceModel> services;

  const AppointmentServicesSection({
    super.key,
    required this.services,
  });

  IconData _getServiceIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('óleo') || lower.contains('oleo')) {
      return Icons.oil_barrel_outlined;
    }
    if (lower.contains('freio') || lower.contains('pastilha')) {
      return Icons.disc_full_outlined;
    }
    if (lower.contains('pneu') ||
        lower.contains('alinhamento') ||
        lower.contains('balanceamento')) {
      return Icons.tire_repair_outlined;
    }
    if (lower.contains('elétric') ||
        lower.contains('eletric') ||
        lower.contains('bateria')) {
      return Icons.battery_charging_full_outlined;
    }
    return Icons.handyman_outlined;
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
                'Serviços selecionados:',
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
                  Icons.handyman_outlined,
                  size: 15,
                  color: Colors.white54,
                ),
                const SizedBox(width: 4),
                Text(
                  '${services.length} ${services.length == 1 ? "Serviço" : "Serviços"}',
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
        if (services.isEmpty) ...[
          const Text(
            'Nenhum serviço vinculado.',
            style: TextStyle(color: Colors.white54),
          ),
        ] else ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: services.map((service) {
                return Container(
                  width: 110,
                  constraints: const BoxConstraints(minHeight: 110),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E22),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFFF7A00),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getServiceIcon(service.name),
                        color: const Color(0xFFFF7A00),
                        size: 32,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
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
