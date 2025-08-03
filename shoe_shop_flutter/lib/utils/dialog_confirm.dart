import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogConfirm extends StatelessWidget {
  final String title;
  final String content;

  const DialogConfirm({
    super.key,
    this.title = 'Cancel Order?',
    this.content = 'Do you really want to cancel this order?',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}