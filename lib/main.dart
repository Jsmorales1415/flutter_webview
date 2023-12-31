import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:html' as html;

void main() {
  createAndSendButton();
  runApp(const MyApp());
}

void createAndSendButton() {
  final button = html.ButtonElement()
    ..innerText = 'Send JSON to Mobile App'
    ..onClick.listen((event) {
      sendJsonMessageToMobileApp();
    });
  html.document.body?.children.add(button);
}

void sendJsonMessageToMobileApp() {
  var jsonMessage = jsonEncode({
    'message': 'Hello from Web App',
    'data': [1, 2, 3, 4, 5]
  });

  // Here you can call a JavaScript function to send the data back to the mobile app
  // For example, using JavaScript channels
  html.window.alert('Sending JSON: $jsonMessage');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webview',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String messageReceived = '';

  void _sendMessage() {
    html.window.parent?.postMessage('Response from Web App', '*');
  }

  @override
  void initState() {
    super.initState();
    html.window.addEventListener('WebApp', (event) {
      html.MessageEvent msg = event as html.MessageEvent;

      setState(() {
        messageReceived = msg.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Tap the button to send a message to Flutter parent',
            ),
            Text('Received: $messageReceived')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send',
        child: const Icon(Icons.add),
      ),
    );
  }
}
