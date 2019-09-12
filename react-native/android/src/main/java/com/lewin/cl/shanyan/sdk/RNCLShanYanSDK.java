package com.lewin.cl.shanyan.sdk;


import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.chuanglan.shanyan_sdk.OneKeyLoginManager;
import com.chuanglan.shanyan_sdk.listener.GetPhoneInfoListener;
import com.chuanglan.shanyan_sdk.listener.InitListener;
import com.chuanglan.shanyan_sdk.listener.OneKeyLoginListener;
import com.chuanglan.shanyan_sdk.listener.OpenLoginAuthListener;
import com.chuanglan.shanyan_sdk.listener.ShanYanCustomInterface;
import com.chuanglan.shanyan_sdk.tool.ShanYanUIConfig;
import com.chuanglan.shanyan_sdk.utils.AbScreenUtils;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.PermissionListener;

import org.json.JSONObject;

import java.util.HashMap;


/**
 * Created by lewin on 2018/3/14.
 */

public class RNCLShanYanSDK extends ReactContextBaseJavaModule {

    private ReactApplicationContext reactContext;

    private static Integer PRE_CODE = 321;

    private Promise prePromise = null;


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
        init(AppId, AppKey, timeOut, promise);
        if (Build.VERSION.SDK_INT >= 23) {
            int checkCallPhonePermission = ContextCompat.checkSelfPermission(reactContext,Manifest.permission.READ_PHONE_STATE);
            if(checkCallPhonePermission != PackageManager.PERMISSION_GRANTED){
                ActivityCompat.requestPermissions(reactContext.getCurrentActivity(),new String[]{Manifest.permission.READ_PHONE_STATE}, PRE_CODE);
                return;
            }
        }
    }

    private void init(final String AppId, final String AppKey, Integer timeOut, final Promise promise) {
        try{
            reactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    OneKeyLoginManager.getInstance().init(reactContext, AppId, AppKey, new InitListener() {
                        @Override
                        public void getInitStatus(int code, String result) {
                            Log.e("VVV", "初始化code=" + code + "result==" + result);
                            try {
                                if (code == 1022) {
                                    WritableMap map = Arguments.createMap();
                                    map.putInt("code", code);
                                    map.putString("message", result);
                                    //权限判断：调用网络初始化和预取号前需要获取READ_PHONE_STATE权限，否则会返回失败状态码
                                    promise.resolve(map);
                                } else {
                                    promise.reject(code + "", result);
                                }
                            }catch (Exception e){
                                e.printStackTrace();
                            }

                        }
                    });
                }
            });
        }catch (Exception e){
            try{
                promise.reject("500", e.getLocalizedMessage());
            }catch (Exception exx) {
                exx.printStackTrace();
            }
        }

    }

    /**
     * 预取号
     *
     * @param promise
     */
    @ReactMethod
    public void preGetPhonenumber(final Promise promise) {
        prePromise = promise;
        if (Build.VERSION.SDK_INT >= 23) {
            int checkCallPhonePermission = ContextCompat.checkSelfPermission(reactContext,Manifest.permission.READ_PHONE_STATE);
            if(checkCallPhonePermission != PackageManager.PERMISSION_GRANTED){
                ActivityCompat.requestPermissions(reactContext.getCurrentActivity(),new String[]{Manifest.permission.READ_PHONE_STATE}, PRE_CODE);
                return;
            }else{
                prePhoneNumber(promise);
            }
        } else {
            prePhoneNumber(promise);
        }

    }

    private void prePhoneNumber(final Promise promise) {
        //闪验SDK预取号
        OneKeyLoginManager.getInstance().getPhoneInfo(new GetPhoneInfoListener() {
            @Override
            public void getPhoneInfoStatus(int code, String result) {
                Log.e("VVV", "初始化code=" + code + "result==" + result);
                try {
                    if (code == 1022) {
                        WritableMap map = Arguments.createMap();
                        map.putInt("code", code);
                        map.putString("message", result);
                        //权限判断：调用网络初始化和预取号前需要获取READ_PHONE_STATE权限，否则会返回失败状态码
                        promise.resolve(map);
                    } else {
                        promise.reject(code + "", result);
                    }
                }catch (Exception e){
                    e.printStackTrace();
                }

            }
        });
    }

    @ReactMethod
    public void quickAuthLogin(ReadableMap configure, Integer timeout, final Promise promise) {
        login(configure, timeout, promise);
    }

    private void login(ReadableMap configure, Integer timeout, final Promise promise) {
        try{
            this.setUIConfig(configure, promise);
            // 是否手动管理销毁授权页
            boolean manualDismiss = false;
            if (configure.hasKey("manualDismiss") && !configure.isNull("manualDismiss")) {
                manualDismiss = configure.getBoolean("manualDismiss");
            }
            OneKeyLoginManager.getInstance().openLoginAuth(manualDismiss, timeout, new OpenLoginAuthListener() {
                @Override
                public void getOpenLoginAuthStatus(int code, String result) {
                    try {
                        if (code != 1000) {
                            promise.reject(code + "", result);
                        }
                    }catch (Exception e){
                        e.printStackTrace();
                    }
                }
            }, new OneKeyLoginListener() {
                @Override
                public void getOneKeyLoginStatus(int code, String result) {
                    try {
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
                    }catch (Exception e){
                        e.printStackTrace();
                    }
                }
            });

        }catch (Exception e){
            try{
                promise.reject("500", e.getLocalizedMessage());
            }catch (Exception exx) {
                exx.printStackTrace();
            }
        }
    }

    private void setUIConfig(ReadableMap configure, final Promise promise) {
        if (configure != null) {

            ShanYanUIConfig.Builder uiConfig = new ShanYanUIConfig.Builder();
            // 头部导航栏相关属性
            if (configure.hasKey("navBarHidden") && !configure.isNull("navBarHidden")) {
                uiConfig.setAuthNavHidden(configure.getBoolean("navBarHidden"));
            }
            if (configure.hasKey("authBG") && !configure.isNull("authBG")) {
                uiConfig.setAuthBGImgPath(configure.getString("authBG"));
            }
            if (configure.hasKey("navBarTintColor") && !configure.isNull("navBarTintColor")) {
                uiConfig.setNavTextColor(Color.parseColor(configure.getString("navBarTintColor")));
            }
            if (configure.hasKey("navBarBackBtnImg") && !configure.isNull("navBarBackBtnImg")) {
                uiConfig.setNavReturnImgPath(configure.getString("navBarBackBtnImg"));
            }
            if (configure.hasKey("navBarBackBtnHidden") && !configure.isNull("navBarBackBtnHidden")) {
                uiConfig.setNavReturnImgHidden(configure.getBoolean("navBarBackBtnHidden"));
            }
            if (configure.hasKey("navBarBGTransparent") && !configure.isNull("navBarBGTransparent")) {
                uiConfig.setAuthNavTransparent(configure.getBoolean("navBarBGTransparent"));
            }
            if (configure.hasKey("navBarTitle") && !configure.isNull("navBarTitle")) {
                uiConfig.setNavText(configure.getString("navBarTitle"));
            }

            // logo
            if (configure.hasKey("logo") && !configure.isNull("logo")) {
                Log.i("a", "logo:" + configure.getString("logo"));
                uiConfig.setLogoImgPath(configure.getString("logo"));
            }
            if (configure.hasKey("logoWidth") && !configure.isNull("logoWidth")) {
                uiConfig.setLogoWidth(configure.getInt("logoWidth"));
            }
            if (configure.hasKey("logoHeight") && !configure.isNull("logoHeight")) {
                uiConfig.setLogoHeight(configure.getInt("logoHeight"));
            }
            if (configure.hasKey("logoOffX") && !configure.isNull("logoOffX")) {
                uiConfig.setLogoOffsetX(configure.getInt("logoOffX"));
            }
            if (configure.hasKey("logoOffY") && !configure.isNull("logoOffY")) {
                uiConfig.setLogoOffsetY(configure.getInt("logoOffY"));
            }
            if (configure.hasKey("logoHidden") && !configure.isNull("logoHidden")) {
                uiConfig.setLogoHidden(configure.getBoolean("logoHidden"));
            }

            // 手机号码
            if (configure.hasKey("phoneFontSize") && !configure.isNull("phoneFontSize")) {
                uiConfig.setNumberSize(configure.getInt("phoneFontSize"));
            }
            if (configure.hasKey("phoneColor") && !configure.isNull("phoneColor")) {
                uiConfig.setNumberColor(Color.parseColor(configure.getString("phoneColor")));
            }
            if (configure.hasKey("phoneWidth") && !configure.isNull("phoneWidth")) {
                uiConfig.setNumFieldWidth(configure.getInt("phoneWidth"));
            }
            if (configure.hasKey("phoneOffX") && !configure.isNull("phoneOffX")) {
                uiConfig.setNumFieldOffsetX(configure.getInt("phoneOffX"));
            }
            if (configure.hasKey("phoneOffY") && !configure.isNull("phoneOffY")) {
                uiConfig.setNumFieldOffsetX(configure.getInt("phoneOffY"));
            }

            // 登录按钮
            if (configure.hasKey("loginTxt") && !configure.isNull("loginTxt")) {
                uiConfig.setLogBtnText(configure.getString("loginTxt"));
            }
            if (configure.hasKey("loginTxtColor") && !configure.isNull("loginTxtColor")) {
                uiConfig.setLogBtnTextColor(Color.parseColor(configure.getString("loginTxtColor")));
            }
            if (configure.hasKey("loginFontSize") && !configure.isNull("loginFontSize")) {
                uiConfig.setLogBtnTextSize(configure.getInt("loginFontSize"));
            }
            if (configure.hasKey("loginWidth") && !configure.isNull("loginWidth")) {
                uiConfig.setLogBtnWidth(configure.getInt("loginWidth"));
            }
            if (configure.hasKey("loginHeight") && !configure.isNull("loginHeight")) {
                uiConfig.setLogBtnHeight(configure.getInt("loginHeight"));
            }

            if (configure.hasKey("loginOffX") && !configure.isNull("loginOffX")) {
                uiConfig.setLogBtnOffsetX(configure.getInt("loginOffX"));
            }
            if (configure.hasKey("loginOffY") && !configure.isNull("loginOffY")) {
                uiConfig.setLogBtnOffsetY(configure.getInt("loginOffY"));
            }
            if (configure.hasKey("loginBGImg") && !configure.isNull("loginBGImg")) {
                uiConfig.setLogBtnImgPath(configure.getString("loginBGImg"));
            }

            if (configure.hasKey("sloganTextSize") && !configure.isNull("sloganTextSize")) {
                uiConfig.setSloganTextSize(configure.getInt("sloganTextSize"));
            }
            if (configure.hasKey("sloganTextColor") && !configure.isNull("sloganTextColor")) {
                uiConfig.setSloganTextColor(Color.parseColor(configure.getString("sloganTextColor")));
            }
            if (configure.hasKey("sloganHidden") && !configure.isNull("sloganHidden")) {
                uiConfig.setSloganHidden(configure.getBoolean("sloganHidden"));
            }
            if (configure.hasKey("sloganOffsetX") && !configure.isNull("sloganOffsetX")) {
                uiConfig.setSloganOffsetX(configure.getInt("sloganOffsetX"));
            }
            if (configure.hasKey("sloganOffsetY") && !configure.isNull("sloganOffsetY")) {
                uiConfig.setSloganOffsetY(configure.getInt("sloganOffsetY"));
            }
            if (configure.hasKey("sloganOffsetBottomY") && !configure.isNull("sloganOffsetBottomY")) {
                uiConfig.setSloganOffsetBottomY(configure.getInt("sloganOffsetBottomY"));
            }


            if (configure.hasKey("appPrivacyOne") && !configure.isNull("appPrivacyOne")) {
                // name,url
                String[] appPrivacyOnes = configure.getString("appPrivacyOne").split(",");
                if (appPrivacyOnes != null && appPrivacyOnes.length > 1) {
                    uiConfig.setAppPrivacyOne(appPrivacyOnes[0], appPrivacyOnes[1]);
                }
            }
            if (configure.hasKey("appPrivacyTwo") && !configure.isNull("appPrivacyTwo")) {
                // name,url
                String[] appPrivacyTwos = configure.getString("appPrivacyTwo").split(",");
                if (appPrivacyTwos != null && appPrivacyTwos.length > 1) {
                    uiConfig.setAppPrivacyTwo(appPrivacyTwos[0], appPrivacyTwos[1]);
                }
            }
            if (configure.hasKey("appPrivacyColor") && !configure.isNull("appPrivacyColor")) {
                String[] appPrivacyColors = configure.getString("appPrivacyColor").split(",");
                if (appPrivacyColors != null && appPrivacyColors.length > 1) {
                    uiConfig.setAppPrivacyColor(Color.parseColor(appPrivacyColors[0]), Color.parseColor(appPrivacyColors[1]));
                }
            }
            if (configure.hasKey("privacyOffsetBottomY") && !configure.isNull("privacyOffsetBottomY")) {
                uiConfig.setPrivacyOffsetBottomY(configure.getInt("privacyOffsetBottomY"));
            }
            if (configure.hasKey("privacyOffsetX") && !configure.isNull("privacyOffsetX")) {
                uiConfig.setPrivacyOffsetX(configure.getInt("privacyOffsetX"));
            }
            if (configure.hasKey("privacyState") && !configure.isNull("privacyState")) {
                uiConfig.setPrivacyState(configure.getBoolean("privacyState"));
            }
            if (configure.hasKey("uncheckedImgPath") && !configure.isNull("uncheckedImgPath")) {
                uiConfig.setUncheckedImgPath(configure.getString("uncheckedImgPath"));
            }
            if (configure.hasKey("checkedImgPath") && !configure.isNull("checkedImgPath")) {
                uiConfig.setCheckedImgPath(configure.getString("checkedImgPath"));
            }
            if (configure.hasKey("checkBoxHidden") && !configure.isNull("checkBoxHidden")) {
                uiConfig.setCheckBoxHidden(configure.getBoolean("checkBoxHidden"));
            }




            // 其他方式登录
            if (configure.hasKey("otherLoginHidden") && !configure.isNull("otherLoginHidden") && !configure.getBoolean("otherLoginHidden")) {
                String btnTxt = configure.hasKey("otherLoginTxt") && !configure.isNull("otherLoginTxt") ? configure.getString("otherLoginTxt") : "其他方式登录";
                int txtColor = configure.hasKey("otherLoginColor") && !configure.isNull("otherLoginColor") ? Color.parseColor(configure.getString("otherLoginColor")) : 0xff3a404c;
                int txtSize = configure.hasKey("otherLoginFontSize") && !configure.isNull("otherLoginFontSize") ? configure.getInt("otherLoginFontSize") : 13;
                int bgColor = configure.hasKey("otherLoginBGColor") && !configure.isNull("otherLoginBGColor") ? Color.parseColor(configure.getString("otherLoginBGColor")) : 0;

                TextView otherTV = new TextView(reactContext);
                otherTV.setText(btnTxt);
                otherTV.setTextColor(txtColor);
                otherTV.setTextSize(TypedValue.COMPLEX_UNIT_SP, txtSize);
                if (bgColor > 0) {
                    otherTV.setBackgroundColor(bgColor);
                }

                RelativeLayout.LayoutParams mLayoutParams1 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
                mLayoutParams1.setMargins(0, AbScreenUtils.dp2px(reactContext, 270), 0, 0);
                mLayoutParams1.addRule(RelativeLayout.CENTER_HORIZONTAL);
                otherTV.setLayoutParams(mLayoutParams1);
                uiConfig.addCustomView(otherTV, true, false, new ShanYanCustomInterface() {
                    @Override
                    public void onClick(Context context, View view) {
                        try {
                            WritableMap map = Arguments.createMap();
                            map.putInt("code", 0);
                            map.putString("message", "其他方式登录");
                            map.putString("data", "");
                            //权限判断：调用网络初始化和预取号前需要获取READ_PHONE_STATE权限，否则会返回失败状态码
                            promise.resolve(map);
                        }catch (Exception e) {
                            e.printStackTrace();
                        }

                    }
                });
            }

            // 其他方式登录
            if (configure.hasKey("rightBtnHidden") && !configure.isNull("rightBtnHidden") && !configure.getBoolean("rightBtnHidden")) {
                ImageButton close = new ImageButton(reactContext);
                if (configure.hasKey("rightBtnBG") && !configure.isNull("rightBtnBG")) {
                    String bgPath = configure.getString("rightBtnBG");
                    Log.i("a", "bgPath:" + bgPath);
                    if (bgPath.indexOf(".") > 0) {
                        close.setImageURI(Uri.parse(bgPath));
                    } else {
                        close.setBackgroundResource(reactContext.getResources().getIdentifier(bgPath,"drawable",reactContext.getPackageName()));
                    }
                }
                RelativeLayout.LayoutParams mLayoutParamsClose = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
                mLayoutParamsClose.setMargins(0,AbScreenUtils.dp2px(reactContext, 10), AbScreenUtils.dp2px(reactContext, 10), 0);
                mLayoutParamsClose.width = configure.hasKey("rightBtnWidth") && !configure.isNull("rightBtnWidth") ? configure.getInt("rightBtnWidth") : AbScreenUtils.dp2px(reactContext, 15);
                mLayoutParamsClose.height = configure.hasKey("rightBtnHeight") && !configure.isNull("rightBtnHeight") ? configure.getInt("rightBtnHeight") : AbScreenUtils.dp2px(reactContext, 15);
                mLayoutParamsClose.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
                close.setLayoutParams(mLayoutParamsClose);
                uiConfig.addCustomView(close, true, false, new ShanYanCustomInterface() {
                    @Override
                    public void onClick(Context context, View view) {
                        try {
                            WritableMap map = Arguments.createMap();
                            map.putInt("code", 1);
                            map.putString("message", "右上角点击");
                            map.putString("data", "");
                            //权限判断：调用网络初始化和预取号前需要获取READ_PHONE_STATE权限，否则会返回失败状态码
                            promise.resolve(map);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                    }
                });
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
            try {
                promise.reject("500",  e.getLocalizedMessage());
            }catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }



}
