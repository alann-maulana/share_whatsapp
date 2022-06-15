#import "ShareWhatsappPlugin.h"
#if __has_include(<share_whatsapp/share_whatsapp-Swift.h>)
#import <share_whatsapp/share_whatsapp-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "share_whatsapp-Swift.h"
#endif

@implementation ShareWhatsappPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftShareWhatsappPlugin registerWithRegistrar:registrar];
}
@end
