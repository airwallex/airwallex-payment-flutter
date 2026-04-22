import 'package:flutter/material.dart';

Future<void> showCredentialsDialog(
  BuildContext context, {
  required String title,
  required String apiKeyLabel,
  required String clientIdLabel,
  required String submitLabel,
  required Future<void> Function(String apiKey, String clientId) onSubmit,
}) async {
  final apiKeyController = TextEditingController();
  final clientIdController = TextEditingController();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: apiKeyController,
                decoration: InputDecoration(labelText: apiKeyLabel),
              ),
              TextField(
                controller: clientIdController,
                decoration: InputDecoration(labelText: clientIdLabel),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await onSubmit(apiKeyController.text, clientIdController.text);
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text(submitLabel),
          ),
        ],
      );
    },
  );
}
