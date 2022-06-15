import 'package:cross_file/cross_file.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'share_whatsapp_method_channel.dart';
import 'src/enums.dart';

abstract class ShareWhatsappPlatform extends PlatformInterface {
  /// Constructs a ShareWhatsappPlatform.
  ShareWhatsappPlatform() : super(token: _token);

  static final Object _token = Object();

  static ShareWhatsappPlatform _instance = MethodChannelShareWhatsapp();

  /// The default instance of [ShareWhatsappPlatform] to use.
  ///
  /// Defaults to [MethodChannelShareWhatsapp].
  static ShareWhatsappPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ShareWhatsappPlatform] when
  /// they register themselves.
  static set instance(ShareWhatsappPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> installed({WhatsApp type = WhatsApp.standard}) {
    throw UnimplementedError('installed() has not been implemented.');
  }

  Future<bool> share({
    WhatsApp type = WhatsApp.standard,
    String? phone,
    String? text,
    XFile? file,
  }) {
    throw UnimplementedError('share() has not been implemented.');
  }
}
