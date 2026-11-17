import 'package:flutter/material.dart';

class ServicesEmptyState extends StatelessWidget {
  const ServicesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Column(
          children: [
            Icon(
              Icons.build_circle_outlined,
              size: 48,
              color: Colors.white30,
            ),
            SizedBox(height: 12),
            Text(
              'Nenhum serviço encontrado',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
