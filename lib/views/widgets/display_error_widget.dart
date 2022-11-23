import 'package:flutter/material.dart';

class DisplayErrorWidget extends StatelessWidget {
  const DisplayErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRefreshPressed,
    this.refreshText = 'Refresh',
  });

  final String errorMessage;
  final VoidCallback onRefreshPressed;
  final String refreshText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(errorMessage),
          ElevatedButton(
            onPressed: onRefreshPressed,
            child: Text(refreshText),
          ),
        ],
      ),
    );
  }
}
