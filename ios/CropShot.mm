#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(CropShot, NSObject)

RCT_EXTERN_METHOD(captureScreenshot:(nonnull NSNumber)x y:(nonnull NSNumber)y width:(nonnull NSNumber)width height:(nonnull NSNumber)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(captureScreenshotWithRef:(nonnull NSNumber)reactTag resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

@end
