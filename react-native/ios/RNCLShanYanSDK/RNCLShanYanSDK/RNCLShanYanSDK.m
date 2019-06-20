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
#define COLOR_HEX(hexValue,alphaValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue]

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

RCT_EXPORT_METHOD(quickAuthLogin:(NSDictionary*)configure success:(RCTPromiseResolveBlock)success failure:(RCTResponseErrorBlock)failure){
    dispatch_sync(dispatch_get_main_queue(), ^{
        @try{
            CLUIConfigure * baseUIConfigure = [self getConfig:configure];
            
            [CLShanYanSDKManager quickAuthLoginWithConfigure:baseUIConfigure timeOut:10 complete:^(CLCompleteResult * _Nonnull completeResult) {
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

-(CLUIConfigure*)getConfig:(NSDictionary*)configure {
    CLUIConfigure * baseUIConfigure = [CLUIConfigure new];
    // LOGO 相关属性
    if (configure[@"logo"]) {
        [baseUIConfigure setClLogoImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:configure[@"logo"]]]];
    }
    if (configure[@"logoWidth"]) {
        [baseUIConfigure setClLogoWidth: configure[@"logoWidth"]];
    }
    if (configure[@"logoHeight"]) {
        [baseUIConfigure setClLogoHeight: configure[@"logoHeight"]];
    }
    if (configure[@"logoOffX"]) {
        [baseUIConfigure setClLogoOffsetX: configure[@"logoOffX"]];
    }
    if (configure[@"logoOffY"]) {
        [baseUIConfigure setClLogoOffsetY: configure[@"logoOffY"]];
    }
    if (configure[@"logoHidden"]) {
        [baseUIConfigure setClLogoHiden:configure[@"logoHidden"]];
    }
    
    // 头部导航栏相关属性
    if (configure[@"navBarHidden"]) {
        [baseUIConfigure setCl_navigation_navigationBarHidden: configure[@"navBarHidden"]];
    }
    if (configure[@"navBarBG"]) {
        [baseUIConfigure setCl_navigation_backgroundImage:configure[@"navBarBG"]];
    }
    if (configure[@"navBarTintColor"]) {
        [baseUIConfigure setCl_navigation_tintColor: COLOR_HEX(configure[@"navBarTintColor"], 1.0)];
    }
    if (configure[@"navBarBackBtnHidden"]) {
        [baseUIConfigure setCl_navigation_backBtnHidden: configure[@"navBarBackBtnHidden"]];
    }
    if (configure[@"navBarBackBtnImg"]) {
        [baseUIConfigure setCl_navigation_backBtnImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:configure[@"navBarBackBtnImg"]]]];
    }
    if (configure[@"navBarBottomLineHidden"]) {
        [baseUIConfigure setCl_navigation_bottomLineHidden:configure[@"navBarBottomLineHidden"]];
    }
    if (configure[@"navBarBGTransparent"]) {
        [baseUIConfigure setCl_navigation_backgroundClear:configure[@"navBarBGTransparent"]];
    }
    
    // .... 其他待提出
    // 手机号码
    if (configure[@"phoneFontSize"]) {
        [baseUIConfigure setClPhoneNumberFont:[UIFont systemFontOfSize:configure[@"phoneFontSize"]]];
    }
    if (configure[@"phoneColor"]) {
        [baseUIConfigure setClPhoneNumberColor:COLOR_HEX(configure[@"phoneColor"], 1)];
    }
    if (configure[@"phoneWidth"]) {
        [baseUIConfigure setClPhoneNumberWidth:configure[@"phoneWidth"]];
    }
    if (configure[@"phoneHeight"]) {
        [baseUIConfigure setClPhoneNumberHeight:configure[@"phoneHeight"]];
    }
    if (configure[@"phoneOffX"]) {
        [baseUIConfigure setClPhoneNumberOffsetX:configure[@"phoneOffX"]];
    }
    if (configure[@"phoneOffY"]) {
        [baseUIConfigure setClPhoneNumberOffsetY:configure[@"phoneOffY"]];
    }
    
    // 登录按钮
    if (configure[@"loginTxt"]) {
        [baseUIConfigure setClLoginBtnText:configure[@"loginTxt"]];
    }
    if (configure[@"loginFontSize"]) {
        [baseUIConfigure setClLoginBtnTextFont:[UIFont systemFontOfSize:configure[@"loginFontSize"]]];
    }
    if (configure[@"loginTxtColor"]) {
        [baseUIConfigure setClLoginBtnTextColor:COLOR_HEX(configure[@"loginTxtColor"], 1)];
    }
    if (configure[@"loginTxt"]) {
        [baseUIConfigure setClLoginBtnText:configure[@"loginTxt"]];
    }
    if (configure[@"loginWidth"]) {
        [baseUIConfigure setClLoginBtnWidth:configure[@"loginWidth"]];
    }
    if (configure[@"loginHeight"]) {
        [baseUIConfigure setClLoginBtnHeight:configure[@"loginHeight"]];
    }
    if (configure[@"loginBGColor"]) {
        [baseUIConfigure setClLoginBtnBgColor:COLOR_HEX(configure[@"loginBGColor"], 1)];
    }
    if (configure[@"loginBorderColor"]) {
        [baseUIConfigure setClLoginBtnBorderColor:COLOR_HEX(configure[@"loginBorderColor"], 1)];
    }
    if (configure[@"loginBorderWidth"]) {
        [baseUIConfigure setClLoginBtnBorderWidth:configure[@"loginBorderWidth"]];
    }
    if (configure[@"loginBGImg"]) {
        [baseUIConfigure setClLoginBtnNormalBgImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:configure[@"loginBGImg"]]]];
    }
    if (configure[@"loginRadius"]) {
        [baseUIConfigure setClLoginBtnCornerRadius:configure[@"loginRadius"]];
    }
    
    //
    
    
    return baseUIConfigure;
}

@end
