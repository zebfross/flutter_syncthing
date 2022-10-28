#import "FlutterSyncthingPlugin.h"
#if __has_include(<flutter_syncthing/flutter_syncthing-Swift.h>)
#import <flutter_syncthing/flutter_syncthing-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_syncthing-Swift.h"
#endif

@implementation FlutterSyncthingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSyncthingPlugin registerWithRegistrar:registrar];
}
@end
