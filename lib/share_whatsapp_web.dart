// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'share_whatsapp_platform_interface.dart';
import 'share_whatsapp_url.dart';

/// A web implementation of the ShareWhatsappPlatform of the ShareWhatsapp plugin.
class ShareWhatsappWeb extends ShareWhatsappUrl {
  /// Constructs a ShareWhatsappWeb
  ShareWhatsappWeb();

  static void registerWith(Registrar registrar) {
    ShareWhatsappPlatform.instance = ShareWhatsappWeb();
  }
}
