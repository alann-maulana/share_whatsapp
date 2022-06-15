#ifndef FLUTTER_PLUGIN_SHARE_WHATSAPP_PLUGIN_H_
#define FLUTTER_PLUGIN_SHARE_WHATSAPP_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace share_whatsapp {

class ShareWhatsappPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ShareWhatsappPlugin();

  virtual ~ShareWhatsappPlugin();

  // Disallow copy and assign.
  ShareWhatsappPlugin(const ShareWhatsappPlugin&) = delete;
  ShareWhatsappPlugin& operator=(const ShareWhatsappPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace share_whatsapp

#endif  // FLUTTER_PLUGIN_SHARE_WHATSAPP_PLUGIN_H_
