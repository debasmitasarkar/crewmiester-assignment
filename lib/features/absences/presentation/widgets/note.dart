import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  const Note({super.key, required this.label, required this.text});
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ) ??
        const TextStyle();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
                text: text,
                style: baseStyle.copyWith(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
