#import "InsImagesPickerPlugin.h"
#if __has_include(<ins_images_picker/ins_images_picker-Swift.h>)
#import <ins_images_picker/ins_images_picker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ins_images_picker-Swift.h"
#endif

@implementation InsImagesPickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInsImagesPickerPlugin registerWithRegistrar:registrar];
}
@end
