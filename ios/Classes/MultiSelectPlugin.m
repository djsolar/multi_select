#import "MultiSelectPlugin.h"
#import <multi_select/multi_select-Swift.h>

@implementation MultiSelectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMultiSelectPlugin registerWithRegistrar:registrar];
}
@end
