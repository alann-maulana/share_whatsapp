#include "include/share_whatsapp/share_whatsapp_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "share_whatsapp_plugin.h"

void ShareWhatsappPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  share_whatsapp::ShareWhatsappPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
