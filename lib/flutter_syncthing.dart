import 'flutter_syncthing_platform_interface.dart';

import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform.isX

final DynamicLibrary nativeAddLib = Platform.isAndroid
    ? DynamicLibrary.open('libsyncthing.so')
    : DynamicLibrary.process();

class FlutterSyncthing {
  Future<String?> getPlatformVersion() {
    return FlutterSyncthingPlatform.instance.getPlatformVersion();
  }
}
