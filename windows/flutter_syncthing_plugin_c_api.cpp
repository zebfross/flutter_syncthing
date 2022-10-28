#include "include/flutter_syncthing/flutter_syncthing_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_syncthing_plugin.h"

void FlutterSyncthingPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_syncthing::FlutterSyncthingPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
