import 'package:flutter/material.dart';

class TimelineGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final String? closingTitle;

  const TimelineGroup({
    super.key,
    required this.title,
    required this.children,
    this.closingTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 6, right: 16),
                width: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE59828), // Cor dourada do Figma
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    for (int i = 0; i < children.length; i++) ...[
                      children[i],
                      if (i < children.length - 1)
                        const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (closingTitle != null) ...[
          const SizedBox(height: 8),
          Text(
            closingTitle!,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}