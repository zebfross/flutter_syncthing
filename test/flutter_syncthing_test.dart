import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_syncthing/flutter_syncthing.dart';
import 'package:flutter_syncthing/flutter_syncthing_platform_interface.dart';
import 'package:flutter_syncthing/flutter_syncthing_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterSyncthingPlatform 
    with MockPlatformInterfaceMixin
    implements FlutterSyncthingPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterSyncthingPlatform initialPlatform = FlutterSyncthingPlatform.instance;

  test('$MethodChannelFlutterSyncthing is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterSyncthing>());
  });

  test('getPlatformVersion', () async {
    FlutterSyncthing flutterSyncthingPlugin = FlutterSyncthing();
    MockFlutterSyncthingPlatform fakePlatform = MockFlutterSyncthingPlatform();
    FlutterSyncthingPlatform.instance = fakePlatform;
  
    expect(await flutterSyncthingPlugin.getPlatformVersion(), '42');
  });
}
