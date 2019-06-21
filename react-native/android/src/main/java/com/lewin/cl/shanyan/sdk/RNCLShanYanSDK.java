package com.lewin.cl.shanyan.sdk;


import android.util.Log;
import android.view.View;

import com.chuanglan.shanyan_sdk.OneKeyLoginManager;
import com.chuanglan.shanyan_sdk.listener.GetPhoneInfoListener;
import com.chuanglan.shanyan_sdk.listener.InitListener;
import com.chuanglan.shanyan_sdk.listener.OneKeyLoginListener;
import com.chuanglan.shanyan_sdk.listener.OpenLoginAuthListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;


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
    public void quickAuthLogin(final Promise promise) {
        OneKeyLoginManager.getInstance().openLoginAuth(false, 10, new OpenLoginAuthListener() {
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
