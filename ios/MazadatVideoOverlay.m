#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(MazadatVideoOverlay, NSObject)

RCT_EXTERN_METHOD(multiply:(float)a b:(float)b
                 resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(playVideo:(NSString *)link
                 resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
