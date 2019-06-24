package com.lewin.cl.shanyan.sdk;


import android.graphics.Color;
import android.util.Log;
import android.view.View;

import com.chuanglan.shanyan_sdk.OneKeyLoginManager;
import com.chuanglan.shanyan_sdk.listener.GetPhoneInfoListener;
import com.chuanglan.shanyan_sdk.listener.InitListener;
import com.chuanglan.shanyan_sdk.listener.OneKeyLoginListener;
import com.chuanglan.shanyan_sdk.listener.OpenLoginAuthListener;
import com.chuanglan.shanyan_sdk.tool.ShanYanUIConfig;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;

import org.json.JSONObject;

import java.util.HashMap;


/**
 * Created by lewin on 2018/3/14.
 */

public class RNCLShanYanSDK extends ReactContextBaseJavaModule {

    private ReactApplicationContext reactContext;



    public RNCLShanYanSDK(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNCLShanYanSDK";
    }

    /**
     * 初始化闪验
     * @param AppId
     * @param AppKey
     * @param timeOut
     * @param promise
     */
    @ReactMethod
    public void initWithAppId(String AppId, String AppKey, Integer timeOut, final Promise promise) {
        OneKeyLoginManager.getInstance().init(reactContext, AppId, AppKey, new InitListener() {
            @Override
            public void getInitStatus(int code, String result) {
                Log.e("VVV", "初始化code=" + code + "result==" + result);
                if (code == 1022) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("code", code);
                    map.putString("message", result);
                    //权限判断：调用网络初始化和预取号前需要获取READ_PHONE_STATE权限，否则会返回失败状态码
                    promise.resolve(map);
                } else {
                    promise.reject(code + "", result);
                }

            }
        });
    }

    /**
     * 预取号
     *
     * @param promise
     */
    @ReactMethod
    public void preGetPhonenumber(final Promise promise) {
        //闪验SDK预取号
        OneKeyLoginManager.getInstance().getPhoneInfo(new GetPhoneInfoListener() {
            @Override
            public void getPhoneInfoStatus(int code, String result) {
                Log.e("VVV", "初始化code=" + code + "result==" + result);
                if (code == 1022) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("code", code);
                    map.putString("message", result);
                    //权限判断：调用网络初始化和预取号前需要获取READ_PHONE_STATE权限，否则会返回失败状态码
                    promise.resolve(map);
                } else {
                    promise.reject(code + "", result);
                }
            }
        });
    }

    @ReactMethod
    public void quickAuthLogin(ReadableMap configure, Integer timeout, final Promise promise) {

        try{
            this.setUIConfig(configure);
            OneKeyLoginManager.getInstance().openLoginAuth(false, timeout, new OpenLoginAuthListener() {
                @Override
                public void getOpenLoginAuthStatus(int code, String result) {
                    if (code != 1000) {
                        promise.reject(code + "", result);
                    }
                }
            }, new OneKeyLoginListener() {
                @Override
                public void getOneKeyLoginStatus(int code, String result) {
                    if (code == 1000) {
                        WritableMap map = Arguments.createMap();
                        map.putInt("code", code);
                        map.putString("message", result);
                        map.putString("data", result);
                        //权限判断：调用网络初始化和预取号前需要获取READ_PHONE_STATE权限，否则会返回失败状态码
                        promise.resolve(map);
                    } else {
                        promise.reject(code + "", result);
                    }
                }
            });

        }catch (Exception e){
            promise.reject("500", e.getLocalizedMessage());
        }


    }

    private void setUIConfig(ReadableMap configure) {
        if (configure != null) {
            ShanYanUIConfig.Builder uiConfig = new ShanYanUIConfig.Builder();
            // 头部导航栏相关属性
            if (!configure.isNull("navBarHidden")) {
                uiConfig.setAuthNavHidden(configure.getBoolean("navBarHidden"));
            }
            if (!configure.isNull("navBarBG")) {
                uiConfig.setAuthBGImgPath(configure.getString("navBarBG"));
            }
            if (!configure.isNull("navBarTintColor")) {
                uiConfig.setNavTextColor(Color.parseColor(configure.getString("navBarTintColor")));
            }
            if (!configure.isNull("navBarBackBtnImg")) {
                uiConfig.setNavReturnImgPath(configure.getString("navBarBackBtnImg"));
            }
            if (!configure.isNull("navBarBackBtnHidden")) {
                uiConfig.setNavReturnImgHidden(configure.getBoolean("navBarBackBtnHidden"));
            }
            if (!configure.isNull("navBarBGTransparent")) {
                uiConfig.setAuthNavTransparent(configure.getBoolean("navBarBGTransparent"));
            }
            if (!configure.isNull("navBarTitle")) {
                uiConfig.setNavText(configure.getString("navBarTitle"));
            }

            // logo
            if (!configure.isNull("logo")) {
                uiConfig.setLogBtnImgPath(configure.getString("logo"));
            }
            if (!configure.isNull("logoWidth")) {
                uiConfig.setLogoWidth(configure.getInt("logoWidth"));
            }
            if (!configure.isNull("logoHeight")) {
                uiConfig.setLogoHeight(configure.getInt("logoHeight"));
            }
            if (!configure.isNull("logoOffX")) {
                uiConfig.setLogoOffsetX(configure.getInt("logoOffX"));
            }
            if (!configure.isNull("logoOffY")) {
                uiConfig.setLogoOffsetY(configure.getInt("logoOffY"));
            }
            if (!configure.isNull("logoHidden")) {
                uiConfig.setLogoHidden(configure.getBoolean("logoHidden"));
            }

            // 手机号码
            if (!configure.isNull("phoneFontSize")) {
                uiConfig.setNumberSize(configure.getInt("phoneFontSize"));
            }
            if (!configure.isNull("phoneColor")) {
                uiConfig.setNumberColor(Color.parseColor(configure.getString("phoneColor")));
            }
            if (!configure.isNull("phoneWidth")) {
                uiConfig.setNumFieldWidth(configure.getInt("phoneWidth"));
            }
            if (!configure.isNull("phoneOffX")) {
                uiConfig.setNumFieldOffsetX(configure.getInt("phoneOffX"));
            }
            if (!configure.isNull("phoneOffY")) {
                uiConfig.setNumFieldOffsetX(configure.getInt("phoneOffY"));
            }

            // 登录按钮
            if (!configure.isNull("loginTxt")) {
                uiConfig.setLogBtnText(configure.getString("loginTxt"));
            }
            if (!configure.isNull("loginTxtColor")) {
                uiConfig.setLogBtnTextColor(Color.parseColor(configure.getString("loginTxtColor")));
            }
            if (!configure.isNull("loginFontSize")) {
                uiConfig.setLogBtnTextSize(configure.getInt("loginFontSize"));
            }
            if (!configure.isNull("loginWidth")) {
                uiConfig.setLogBtnWidth(configure.getInt("loginWidth"));
            }
            if (!configure.isNull("loginHeight")) {
                uiConfig.setLogBtnHeight(configure.getInt("loginHeight"));
            }

            if (!configure.isNull("loginOffX")) {
                uiConfig.setLogBtnOffsetX(configure.getInt("loginOffX"));
            }
            if (!configure.isNull("loginOffY")) {
                uiConfig.setLogBtnOffsetY(configure.getInt("loginOffY"));
            }

            OneKeyLoginManager.getInstance().setAuthThemeConfig(uiConfig.build());
        }
    }

    @ReactMethod
    public void closeLogin(final Promise promise) {
        try {
            OneKeyLoginManager.getInstance().finishAuthActivity();
            WritableMap map = Arguments.createMap();
            map.putInt("code", 1000);
            map.putString("message", "销毁成功");
            promise.resolve(map);
        }catch (Exception e) {
            promise.reject("500",  e.getLocalizedMessage());
        }
    }



}
