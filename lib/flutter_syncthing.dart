import 'flutter_syncthing_platform_interface.dart';

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_syncthing/bridge/binding_stub.dart'
    if (dart.library.io) 'package:flutter_syncthing/bridge/binding.dart'
    if (dart.library.io ==
        "false") 'package:flutter_syncthing/bridge/binding_stub.dart';
import 'package:flutter_syncthing/model/bridge_model_generated.dart' as model;

class SyncthingException implements Exception {
  String cause;

  SyncthingException(this.cause);
}

class FlutterSyncthing {
  static bool bindingEnabled = Binding().isSupported();

  static Future<Uint8List> _call(String name, Uint8List payload) async {
    if (bindingEnabled) {
      return await Binding().callAsync(name, payload);
    }

    throw new SyncthingException('Binding not enabled');
  }

  static Future<Uint8List> _bytesResponse(
      String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.BytesResponse(data);
    if (response.error != null && response.error != "") {
      throw new SyncthingException(response.error!);
    }
    return Uint8List.fromList(response.output!);
  }

  static Future<String> _stringResponse(String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.StringResponse(data);
    if (response.error != null && response.error != "") {
      throw new SyncthingException(response.error!);
    }
    return response.output!;
  }

  static Future<bool> _boolResponse(String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.BoolResponse(data);
    if (response.error != null && response.error != "") {
      throw new SyncthingException(response.error!);
    }
    return response.output;
  }

  Future<String?> getPlatformVersion() {
    return FlutterSyncthingPlatform.instance.getPlatformVersion();
  }
}
