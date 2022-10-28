import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_syncthing_platform_interface.dart';

/// An implementation of [FlutterSyncthingPlatform] that uses method channels.
class MethodChannelFlutterSyncthing extends FlutterSyncthingPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_syncthing');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
