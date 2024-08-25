//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_blue_plus/FlutterBluePlusPlugin.h>)
#import <flutter_blue_plus/FlutterBluePlusPlugin.h>
#else
@import flutter_blue_plus;
#endif

#if __has_include(<wifi_iot/WifiIotPlugin.h>)
#import <wifi_iot/WifiIotPlugin.h>
#else
@import wifi_iot;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterBluePlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterBluePlusPlugin"]];
  [WifiIotPlugin registerWithRegistrar:[registry registrarForPlugin:@"WifiIotPlugin"]];
}

@end
