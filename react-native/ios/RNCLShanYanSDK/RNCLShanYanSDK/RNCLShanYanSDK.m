//
//  RNCLShanYangSDK.m
//  RNCLShanYanSDK
//
//  Created by lewin on 2019/6/18.
//  Copyright © 2019 lewin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNCLShanYanSDK.h"
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>

@implementation RNCLShanYanSDK
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initWithAppId:(NSString*)AppId AppKey:(NSString*)AppKey timeOut:(NSTimeInterval)timeOut success:(RCTPromiseResolveBlock)success failure:(RCTResponseErrorBlock)failure){
    dispatch_sync(dispatch_get_main_queue(), ^{
        @try{
            [CLShanYanSDKManager initWithAppId:AppId AppKey:AppKey timeOut:timeOut complete:^(CLCompleteResult * _Nonnull completeResult) {
                if (completeResult.error != nil) {
                    failure(completeResult.error);
                } else {
                    NSMutableDictionary *dict = [NSMutableDictionary new];
                    [dict setObject:@(completeResult.code) forKey:@"code"];
                    [dict setObject:completeResult.message forKey:@"message"];
                    [dict setObject:completeResult.data forKey:@"data"];
                    [dict setObject:@(completeResult.authPagePresented) forKey:@"authPagePresented"];
                    success(dict);
                }
            }];
        }@catch(NSException *ex){
            NSString *domain = @"lewin.error";
            NSString *desc = NSLocalizedString(@"初始化失败", @"");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain
                                                 code:500
                                             userInfo:userInfo];
            failure(error);
        }
    });
}

RCT_EXPORT_METHOD(preGetPhonenumber:(RCTPromiseResolveBlock)success failure:(RCTResponseErrorBlock)failure){
    dispatch_sync(dispatch_get_main_queue(), ^{
        @try{
            [CLShanYanSDKManager preGetPhonenumber:^(CLCompleteResult * _Nonnull completeResult) {
                if (completeResult.error != nil) {
                    failure(completeResult.error);
                } else {
                    NSMutableDictionary *dict = [NSMutableDictionary new];
                    [dict setObject:@(completeResult.code) forKey:@"code"];
                    [dict setObject:completeResult.message forKey:@"message"];
                    [dict setObject:completeResult.data forKey:@"data"];
                    [dict setObject:@(completeResult.authPagePresented) forKey:@"authPagePresented"];
                    success(dict);
                }
                
                
            }];
        }@catch(NSException *ex){
            NSString *domain = @"lewin.error";
            NSString *desc = NSLocalizedString(@"初始化失败", @"");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain
                                                 code:500
                                             userInfo:userInfo];
            failure(error);
        }
    });
}

RCT_EXPORT_METHOD(quickAuthLoginWithConfigure:(NSDictionary*)configure success:(RCTPromiseResolveBlock)success failure:(RCTResponseErrorBlock)failure){
    dispatch_sync(dispatch_get_main_queue(), ^{
        @try{
            
            CLUIConfigure * baseUIConfigure = [CLUIConfigure new];
            [CLShanYanSDKManager quickAuthLoginWithConfigure:baseUIConfigure timeOut:10 complete:^(CLCompleteResult * _Nonnull completeResult) {
                
            }];
        }@catch(NSException *ex){
            NSString *domain = @"lewin.error";
            NSString *desc = NSLocalizedString(@"初始化失败", @"");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain
                                                 code:500
                                             userInfo:userInfo];
            failure(error);
        }
    });
}

@end
