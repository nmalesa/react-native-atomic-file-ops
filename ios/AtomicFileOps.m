#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(AtomicFileOps, NSObject)

RCT_EXTERN_METHOD(multiply:(float)a withB:(float)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(writeFile:(NSString)filePath withData:(NSString)data withOptions:(NSString)options
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

@end
