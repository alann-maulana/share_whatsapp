/// WhatsApp application type
enum WhatsApp { standard, business }

extension WhatsAppExtension on WhatsApp {
  String get packageName {
    switch (this) {
      case WhatsApp.standard:
        return 'com.whatsapp';
      case WhatsApp.business:
        return 'com.whatsapp.w4b';
    }
  }
}
