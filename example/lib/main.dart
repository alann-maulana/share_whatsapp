import 'dart:async';

import 'package:flimer/flimer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_whatsapp/share_whatsapp.dart';

const _kTextMessage = 'Share text from share_whatsapp flutter package '
    'https://pub.dev/packages/whatsapp_share';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _mapInstalled =
      WhatsApp.values.asMap().map<WhatsApp, String?>((key, value) {
    return MapEntry(value, null);
  });

  @override
  void initState() {
    super.initState();
    _checkInstalledWhatsApp();
  }

  Future<void> _checkInstalledWhatsApp() async {
    String whatsAppInstalled = await _check(WhatsApp.standard),
        whatsAppBusinessInstalled = await _check(WhatsApp.business);

    if (!mounted) return;

    setState(() {
      _mapInstalled[WhatsApp.standard] = whatsAppInstalled;
      _mapInstalled[WhatsApp.business] = whatsAppBusinessInstalled;
    });
  }

  Future<String> _check(WhatsApp type) async {
    try {
      return await shareWhatsapp.installed(type: type)
          ? 'INSTALLED'
          : 'NOT INSTALLED';
    } on PlatformException catch (e) {
      return e.message ?? 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Share WhatsApp Example'),
        ),
        body: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              const ListTile(title: Text('STATUS INSTALLATION')),
              ...WhatsApp.values.map((type) {
                final status = _mapInstalled[type];

                return ListTile(
                  title: Text(type.toString()),
                  trailing: status != null
                      ? Text(status)
                      : const CircularProgressIndicator.adaptive(),
                );
              }),
              const ListTile(title: Text('SHARE CONTENT')),
              ListTile(
                title: const Text('Share Text'),
                trailing: const Icon(Icons.share),
                onTap: () => shareWhatsapp.shareText(_kTextMessage),
              ),
              ListTile(
                title: const Text('Share Image'),
                trailing: const Icon(Icons.share),
                onTap: () async {
                  final file = await flimer.pickImage();
                  if (file != null) {
                    shareWhatsapp.shareFile(file);
                  }
                },
              ),
              ListTile(
                title: const Text('Share Text & Image'),
                trailing: const Icon(Icons.share),
                onTap: () async {
                  final file = await flimer.pickImage();
                  if (file != null) {
                    shareWhatsapp.share(text: _kTextMessage, file: file);
                  }
                },
              ),
              ListTile(
                title: const Text('Share Text on Specific Phone Number'),
                trailing: const Icon(Icons.share),
                onTap: () => shareWhatsapp.share(
                  text: _kTextMessage,
                  // change with real whatsapp number
                  phone: '+0 000-0000-00000',
                ),
              ),
            ],
          ).toList(),
        ),
      ),
    );
  }
}
