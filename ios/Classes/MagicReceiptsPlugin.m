#import "MagicReceiptsPlugin.h"
#if __has_include(<magic_receipts/magic_receipts-Swift.h>)
#import <magic_receipts/magic_receipts-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "magic_receipts-Swift.h"
#endif

@implementation MagicReceiptsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMagicReceiptsPlugin registerWithRegistrar:registrar];
}
@end
