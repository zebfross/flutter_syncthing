import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_syncthing_method_channel.dart';

abstract class FlutterSyncthingPlatform extends PlatformInterface {
  /// Constructs a FlutterSyncthingPlatform.
  FlutterSyncthingPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSyncthingPlatform _instance = MethodChannelFlutterSyncthing();

  /// The default instance of [FlutterSyncthingPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSyncthing].
  static FlutterSyncthingPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterSyncthingPlatform] when
  /// they register themselves.
  static set instance(FlutterSyncthingPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
