//
//  RNCLShanYanSDK.h
//  RNCLShanYanSDK
//
//  Created by lewin on 2019/6/18.
//  Copyright © 2019 lewin. All rights reserved.
//

#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#elif __has_include("React/RCTBridgeModule.h")
#import "React/RCTBridgeModule.h"
#else
#import "RCTBridgeModule.h"
#endif


//! Project version number for RNCLShanYanSDK.
FOUNDATION_EXPORT double RNCLShanYanSDKVersionNumber;

//! Project version string for RNCLShanYanSDK.
FOUNDATION_EXPORT const unsigned char RNCLShanYanSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <RNCLShanYanSDK/PublicHeader.h>

NS_ASSUME_NONNULL_BEGIN
@interface RNCLShanYanSDK : NSObject <RCTBridgeModule>



@end
NS_ASSUME_NONNULL_END
