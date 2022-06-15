import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:share_whatsapp/src/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import 'share_whatsapp_platform_interface.dart';

/// A general implementation of [ShareWhatsappPlatform] that uses url_launcher.
class ShareWhatsappUrl extends ShareWhatsappPlatform {
  ShareWhatsappUrl();

  /// Registers this class as the default instance of [ShareWhatsappPlatform].
  static void registerWith() {
    ShareWhatsappPlatform.instance = ShareWhatsappUrl();
  }

  @override
  Future<bool> installed({WhatsApp type = WhatsApp.standard}) async {
    return await canLaunchUrl(Uri.https('wa.me', 'installed'));
  }

  @override
  Future<bool> share({
    WhatsApp type = WhatsApp.standard,
    String? phone,
    String? text,
    XFile? file,
  }) async {
    assert(phone != null, 'Phone parameter is required');
    assert(text != null, 'Text parameter is required');

    final url = Uri.https(
      'wa.me',
      phone!.removeNonNumber(),
      <String, String>{'text': text!},
    );

    if (await canLaunchUrl(url)) {
      return await launchUrl(url);
    }

    return false;
  }
}
