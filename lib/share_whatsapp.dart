import 'package:cross_file/cross_file.dart';

import 'share_whatsapp_platform_interface.dart';
import 'src/enums.dart';

export 'package:cross_file/cross_file.dart';
export 'src/enums.dart' show WhatsApp;

class ShareWhatsapp {
  Future<bool> installed({WhatsApp type = WhatsApp.standard}) {
    return ShareWhatsappPlatform.instance.installed(type: type);
  }

  Future<bool> shareText(String text,
          {String? phone, WhatsApp type = WhatsApp.standard}) =>
      share(type: type, text: text, phone: phone);

  Future<bool> shareFile(XFile file,
          {String? phone, WhatsApp type = WhatsApp.standard}) =>
      share(type: type, file: file, phone: phone);

  Future<bool> share({
    WhatsApp type = WhatsApp.standard,
    String? phone,
    String? text,
    XFile? file,
  }) {
    assert(!(text == null && file == null), "Either set text and or file");

    return ShareWhatsappPlatform.instance
        .share(type: type, phone: phone, text: text, file: file);
  }
}
