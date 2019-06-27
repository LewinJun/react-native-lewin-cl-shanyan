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

@interface RNCLShanYanSDK ()

@property(nonatomic, assign) RCTPromiseResolveBlock successBlock;

@end

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
    self.successBlock = success;
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

RCT_EXPORT_METHOD(closeLogin:(RCTPromiseResolveBlock)success failure:(RCTResponseErrorBlock)failure){
    dispatch_sync(dispatch_get_main_queue(), ^{
        @try{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController *vc = [[self class] getCurrentViewController];
                [vc dismissViewControllerAnimated:YES completion:nil];
                NSMutableDictionary *dict = [NSMutableDictionary new];
                [dict setObject:@(1000) forKey:@"code"];
                [dict setObject:@"成功" forKey:@"message"];
                [dict setObject:@"" forKey:@"data"];
                success(dict);
            });
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

#pragma mark - UI配置闪验
-(CLUIConfigure*)getConfig:(NSDictionary*)configure {
    CLUIConfigure * baseUIConfigure = [CLUIConfigure new];
    baseUIConfigure.viewController = [RNCLShanYanSDK getCurrentViewController];
    // LOGO 相关属性
    if (configure[@"logo"]) {
        [baseUIConfigure setClLogoImage:[self getImgPath:configure[@"authBG"]]];
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
    if (configure[@"authBG"]) {
        
        [baseUIConfigure setCl_navigation_backgroundImage:[self getImgPath:configure[@"authBG"]]];
    }
    if (configure[@"navBarTintColor"]) {
        [baseUIConfigure setCl_navigation_tintColor:[self colorWithHexString:configure[@"navBarTintColor"] alpha:1]];
    }
    if (configure[@"navBarBackBtnHidden"]) {
        [baseUIConfigure setCl_navigation_backBtnHidden: configure[@"navBarBackBtnHidden"]];
    }
    if (configure[@"navBarBackBtnImg"]) {
        [baseUIConfigure setCl_navigation_backBtnImage:[self getImgPath:configure[@"authBG"]]];
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
        [baseUIConfigure setClPhoneNumberFont:[UIFont systemFontOfSize:[configure[@"phoneFontSize"] floatValue]]];
    }
    if (configure[@"phoneColor"]) {
        [baseUIConfigure setClPhoneNumberColor:[self colorWithHexString:configure[@"phoneColor"] alpha:1]];
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
        [baseUIConfigure setClLoginBtnTextFont:[UIFont systemFontOfSize:[configure[@"loginFontSize"] floatValue]]];
    }
    if (configure[@"loginTxtColor"]) {
        [baseUIConfigure setClLoginBtnTextColor:[self colorWithHexString:configure[@"loginTxtColor"] alpha:1]];
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
        [baseUIConfigure setClLoginBtnBgColor:[self colorWithHexString:configure[@"loginBGColor"] alpha:1]];
    }
    if (configure[@"loginBorderColor"]) {
        [baseUIConfigure setClLoginBtnBorderColor:[self colorWithHexString:configure[@"loginBorderColor"] alpha:1]];
    }
    if (configure[@"loginBorderWidth"]) {
        [baseUIConfigure setClLoginBtnBorderWidth:configure[@"loginBorderWidth"]];
    }
    if (configure[@"loginBGImg"]) {
        [baseUIConfigure setClLoginBtnNormalBgImage: [self getImgPath:configure[@"authBG"]]];
    }
    if (configure[@"loginRadius"]) {
        [baseUIConfigure setClLoginBtnCornerRadius:configure[@"loginRadius"]];
    }
    
    //sloganTextColor
    if (configure[@"sloganTextSize"]) {
        [baseUIConfigure setClSloganTextFont:[UIFont systemFontOfSize:[configure[@"sloganTextSize"] floatValue]]];
    }
    if (configure[@"sloganTextColor"]) {
        [baseUIConfigure setClSloganTextColor:[self colorWithHexString:configure[@"sloganTextColor"] alpha:1]];
    }
    //sloganOffsetX
    if (configure[@"sloganHidden"]) {
        [baseUIConfigure setClSloganTextColor:[UIColor clearColor]];
    }
    if (configure[@"sloganOffsetX"]) {
        [baseUIConfigure setClSloganOffsetX:configure[@"sloganOffsetX"]];
    }
    if (configure[@"sloganOffsetY"]) {
        [baseUIConfigure setClSloganOffsetY:configure[@"sloganOffsetY"]];
    }
    
    if (configure[@"sloganOffsetY"]) {
        [baseUIConfigure setClAppPrivacyFirst:@[]];
    }
   
    if (configure[@"appPrivacyOne"]) {
        // name,url
        NSString *oneStr = [NSString stringWithFormat:@"%@", configure[@"appPrivacyOne"]];
        NSArray *ones = [oneStr componentsSeparatedByString:@","];
        if (ones != nil) {
            baseUIConfigure.clAppPrivacyFirst = ones;
        }
    }
    if (configure[@"appPrivacyTwo"]) {
        // name,url
        NSString *oneStr = [NSString stringWithFormat:@"%@", configure[@"appPrivacyTwo"]];
        NSArray *ones = [oneStr componentsSeparatedByString:@","];
        if (ones != nil) {
            baseUIConfigure.clAppPrivacySecond = ones;
        }
    }
    if (configure[@"appPrivacyColor"]) {
        // name,url
        NSString *colorStr = [NSString stringWithFormat:@"%@", configure[@"appPrivacyColor"]];
        NSArray *colors = [colorStr componentsSeparatedByString:@","];
        if (colors != nil) {
            baseUIConfigure.clAppPrivacyColor = colors;
        }
    }
    if (configure[@"privacyOffsetY"]) {
        baseUIConfigure.clAppPrivacyOffsetY = configure[@"privacyOffsetY"];
    }
    if (configure[@"privacyState"]) {
        baseUIConfigure.clCheckBoxValue = configure[@"privacyState"];
    }
    if (configure[@"checkedImgPath"]) {
        baseUIConfigure.clCheckBoxCheckedImage = [self getImgPath:configure[@"checkedImgPath"]];
    }
    if (configure[@"uncheckedImgPath"]) {
        baseUIConfigure.clCheckBoxUncheckedImage = [self getImgPath:configure[@"uncheckedImgPath"]];
    }
    if (configure[@"checkBoxHidden"]) {
        baseUIConfigure.clCheckBoxHidden = configure[@"checkBoxHidden"];
    }
    CGFloat screenScale = [UIScreen mainScreen].bounds.size.width/375.0;
    CGSize screen = UIScreen.mainScreen.bounds.size;
    baseUIConfigure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        //customAreaView为导航条以下的全屏 375*667比例系数适配 默认375*667下一键登录button底部y约为 270
        if(![configure[@"otherLoginHidden"] boolValue]) {
            NSString *otherTxt = configure[@"otherLoginTxt"] != nil ? configure[@"otherLoginTxt"] : @"其他登录方式";
            UIFont *font = configure[@"otherLoginFontSize"] != nil ? [UIFont systemFontOfSize:[configure[@"otherLoginFontSize"] floatValue]] : [UIFont systemFontOfSize:12];
            UIColor *color = configure[@"otherLoginColor"] != nil ? [self colorWithHexString:configure[@"otherLoginColor"] alpha:1.0] : [UIColor whiteColor];
            
            CGSize titleSize = [otherTxt sizeWithAttributes:@{NSFontAttributeName: font}];
            UIButton *button = [[UIButton alloc] init];
            if (configure[@"otherLoginBGColor"]) {
                [button setBackgroundColor:[self colorWithHexString:configure[@"otherLoginBGColor"] alpha:1]];
            }
            [button setTitle:otherTxt forState:(UIControlStateNormal)];
            [button setTintColor:[UIColor whiteColor]];
            button.titleLabel.font = font;
            [button setTitleColor:color forState:UIControlStateNormal];
            [customAreaView addSubview:button];
            [button addTarget:self action:@selector(setOtherClick:) forControlEvents:UIControlStateNormal];
            button.tag = 0;
            button.frame = CGRectMake(0.5 * (screen.width - titleSize.width), 450*screenScale, screen.width, screen.height);
        }
        if (![configure[@"rightBtnHidden"] boolValue]) {
            UIButton *button = [[UIButton alloc] init];
            if (configure[@"rightBtnBG"]) {
                [button setImage:[self getImgPath:configure[@"rightBtnBG"]] forState:UIControlStateNormal];
            }
            CGFloat width = configure[@"rightBtnWidth"] != nil ? [configure[@"rightBtnWidth"] floatValue] : 40;
            CGFloat height = configure[@"rightBtnHeight"] != nil ? [configure[@"rightBtnHeight"] floatValue] : 40;
            button.contentMode = UIViewContentModeScaleToFill;
            button.frame = CGRectMake(screen.width - width - 20, 30, width, height);
            [button addTarget:self action:@selector(setOtherClick) forControlEvents:UIControlStateNormal];
            button.tag = 1;
            [customAreaView addSubview:button];
        }
        
    };
    //otherLoginHidden
    
    return baseUIConfigure;
}

-(void)setOtherClick:(UIButton *)btn {
    long code = btn.tag;
    NSString *message = btn.tag == 0 ? @"其他方式登录" : @"右上角点击";
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@(code) forKey:@"code"];
    [dict setObject:message forKey:@"message"];
    if (self.successBlock != nil) {
        self.successBlock(dict);
    }
    
}

- (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    hexString = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSRegularExpression *RegEx = [NSRegularExpression regularExpressionWithPattern:@"^[a-fA-F|0-9]{6}$" options:0 error:nil];
    NSUInteger match = [RegEx numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, hexString.length)];
    
    if (match == 0) {return [UIColor clearColor];}
    
    NSString *rString = [hexString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [hexString substringWithRange:NSMakeRange(4, 2)];
    unsigned int r, g, b;
    BOOL rValue = [[NSScanner scannerWithString:rString] scanHexInt:&r];
    BOOL gValue = [[NSScanner scannerWithString:gString] scanHexInt:&g];
    BOOL bValue = [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (rValue && gValue && bValue) {
        return [UIColor colorWithRed:((float)r/255.0f) green:((float)g/255.0f) blue:((float)b/255.0f) alpha:alpha];
    } else {
        return [UIColor clearColor];
    }
}

-(UIImage*)getImgPath:(NSString*)path {
    
    NSData *data = nil;
    UIImage *img = nil;
    if ([path rangeOfString:@"http"].location == 0) {
        data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    } else {
        data = [[NSData alloc] initWithContentsOfFile:path];
    }
    if (data == nil) {
        img = [UIImage imageNamed:path];
    } else {
        img = [UIImage imageWithData:data];
    }
    return img;
}

#pragma -mark 获取当前的ViewController
/**
 * @brief 获取当前的ViewController
 *
 */
+ (UINavigationController *)getCurrentNavigationController
{
    UINavigationController *nvc = [[self class] __expectedVisibleNavigationController];
    return nvc;
}

+(UIViewController*_Nonnull)getCurrentViewController{
    return [[[self class] getCurrentNavigationController] visibleViewController];
}

+ (UINavigationController *)__expectedVisibleNavigationController
{
    UINavigationController *nvc = [[self class] expectedVisibleNavigationController];
    if ([nvc isKindOfClass:[UINavigationController class]])
    {
        return nvc;
    }
    else
    {
        UIViewController *vc = [self __visibleViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
        UINavigationController *nvc = (UINavigationController *)([vc isKindOfClass:[UINavigationController class]] ? vc : vc.navigationController);
        return nvc;
    }
}

+ (UIViewController *)__visibleViewController
{
    UIViewController *vc = [self __visibleViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
    return vc;
}

+ (UIViewController*)__visibleViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tbc = (UITabBarController*)rootViewController;
        return [self __visibleViewControllerWithRootViewController:tbc.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nvc = (UINavigationController*)rootViewController;
        return [self __visibleViewControllerWithRootViewController:nvc.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController *presentedVC = rootViewController.presentedViewController;
        return [self __visibleViewControllerWithRootViewController:presentedVC];
    }
    else
    {
        return rootViewController;
    }
}

+ (UINavigationController *)expectedVisibleNavigationController
{
    return (UINavigationController *)@"miss";
}

@end
