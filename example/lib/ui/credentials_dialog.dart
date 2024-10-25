import 'package:flutter/material.dart';

Future<void> showCredentialsDialog(BuildContext context, Function(String, String) onSubmit) async {
  TextEditingController apiKeyController = TextEditingController();
  TextEditingController clientIdController = TextEditingController();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter API Key and Client ID'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: apiKeyController,
                decoration: const InputDecoration(labelText: 'API Key'),
              ),
              TextField(
                controller: clientIdController,
                decoration: const InputDecoration(labelText: 'Client ID'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Submit'),
            onPressed: () {
              onSubmit(apiKeyController.text, clientIdController.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}