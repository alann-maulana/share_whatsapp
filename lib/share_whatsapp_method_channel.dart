import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:share_whatsapp/src/extensions.dart';

import 'share_whatsapp_platform_interface.dart';
import 'src/enums.dart';

/// An implementation of [ShareWhatsappPlatform] that uses method channels.
class MethodChannelShareWhatsapp extends ShareWhatsappPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('share_whatsapp');

  @override
  Future<bool> installed({WhatsApp type = WhatsApp.standard}) async {
    final installed = await methodChannel.invokeMethod<int>(
      'installed',
      type.packageName,
    );

    return installed == 1;
  }

  @override
  Future<bool> share({
    WhatsApp type = WhatsApp.standard,
    String? phone,
    String? text,
    XFile? file,
  }) async {
    String? contentType;
    if (file != null) {
      final bytes = await file.readAsBytes();
      contentType = lookupMimeType(file.path, headerBytes: bytes.toList());
    }

    final shared = await methodChannel.invokeMethod<int>('share', {
      'packageName': type.packageName,
      'phone': phone?.removeNonNumber(),
      'text': text,
      'file': file?.path,
      'contentType': contentType,
    });

    return shared == 1;
  }
}
