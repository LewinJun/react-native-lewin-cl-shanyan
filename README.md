# RNCLShanYanSDK
创蓝 253 闪验SDK(ios v2.2.0.3   andorid v2.2.0.1)， 基于官网的SDK封装RN(React Native)版本


> 不是创蓝内部员工，只是公司刚好用到这个，app是RN版本，封装一层RN皮，贡献出来给各位需要的，我公司app也用这个,会同步更新，有问题欢迎提Issues
> 或者加我微信 junxian_weixin 加入群聊及时通知


## 添加库 
> yarn add react-native-lewin-cl-shanyan

> react-native link react-native-lewin-cl-shanyan
## android配置
1. 权限配置AndroidManifest.xml文件

官网地址 http://flash.253.com/document/details?lid=298&cid=93&pc=28&pn=%25E9%2597%25AA%25E9%25AA%258CSDK

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.WRITE_SETTINGS"/>
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE"/>
<uses-permission android:name="android.permission.GET_TASKS"/>
```

activity配置

```xml
<activity
    android:name="com.sdk.mobile.manager.login.cucc.OauthActivity"
    android:launchMode="singleTop"
    android:screenOrientation="portrait" />
<!--  **********************移动授权页activity**************************-->
<activity
    android:name="com.cmic.sso.sdk.activity.LoginAuthActivity"
    android:launchMode="singleTop"
    android:screenOrientation="portrait" />
<!--  **********************电信授权页activity**************************-->
<activity
    android:name="com.chuanglan.shanyan_sdk.view.ShanYanOneKeyActivity"
    android:launchMode="singleTop"
    android:screenOrientation="portrait" />
<!--  **********************协议页activity**************************-->
<activity
    android:name="com.chuanglan.shanyan_sdk.view.CTCCPrivacyProtocolActivity"
    android:launchMode="singleTop"
    android:screenOrientation="portrait" />
```

## iOS配置
1. 把sdk里面的CL_ShanYanDependenceSDK复制到工程里面，闪验原生的SDK或者可以使用pod
2. 集成指定版本闪验SDK:pod 'CL_ShanYanSDK', '2.2.0.3'
> 官网 http://flash.253.com/document/details?lid=299&cid=93&pc=28&pn=%25E9%2597%25AA%25E9%25AA%258CSDK

## RN API
> import RNCLShanYanSDK from 'react-native-lewin-cl-shanyan'

1. 初始化  
```javascript
try {
    
    const res = await RNCLShanYanSDK.initWithAppId({ appId: getShanYanAppId(), appKey: getShanYanAppKey(), timeOut: 10 });
    console.log(res);
  } catch (e) {
    console.log(e);
  }
```

2. 预取号和拿最终信息
```javascript
const login = async ()=> {
      try{
        const res = await RNCLShanYanSDK.quickAuthLogin({otherLoginHidden: false, rightBtnHidden: false, 
          sloganHidden: true, logoOffY: 10, logo: 'umcsdk_mobile_logo', logoWidth: 200, logoOffX: 5, 
          otherLoginColor: "#284DA3", otherLoginFontSize: 15, navBarHidden: true, rightBtnBG: 'close', 
          rightBtnWidth: 60, rightBtnHeight: 60, checkBoxHidden: true, appPrivacyOne: "協議名稱,https://www.baidu.com" }, 10);
        console.log(res);
        // res {code, message, data}
        // code 等于0 是其他方式  1  是右上角关闭点击
        // 成功拿到就关闭一键登录
        const res1 = await RNCLShanYanSDK.closeLogin();
        console.log(res1);
      }catch(e){
        console.log(e)
      }
    }
    console.log("login");
    try{
      // 预取号
      const res = await RNCLShanYanSDK.preGetPhonenumber();
      console.log(res)
      // 然后登陆
      login();
    }catch(e){
      console.log(e)
    }
```

## quickAuthLogin登录参数说明

> 参考API注释说明
```javascrip
/**
   * img logo sdk暂时只支持 android drawable,不能放在RN JS目录
   * @param {*} param0 logo 图片require  phone 电话号码  login 登录按钮  navBar 头部导航栏 otherLogin 其他方式登录
   * appPrivacyOne/appPrivacyTwo "name,url" 组合
   * privacyState true false 是否选中 协议勾选框 默认为true
   * @param {*} timeOut 超时时间
   */
  static quickAuthLogin(params = {logo: null, logoWidth : null, logoHeight : null, 
    logoOffX : null, logoOffY : null, logoHidden : null, 
    phoneFontSize : null, phoneColor : null, phoneWidth : null, phoneOffX : null, 
    phoneOffY : null, loginTxt : null, loginTxtColor : null, loginFontSize : null, loginWidth : null, 
    loginHeight : null, loginOffX : null, loginOffY : null, navBarHidden : null, authBG : null
    , navBarTintColor : null, navBarBackBtnImg : null, navBarBackBtnHidden : null, navBarBGTransparent : null, navBarTitle : null, 
    otherLoginHidden : false, otherLoginTxt : null, otherLoginColor : null, otherLoginFontSize : null, otherLoginBGColor : null,
    rightBtnHidden : false, rightBtnBG : null, rightBtnWidth : null, rightBtnHeight : null,
    sloganTextSize : null, sloganTextColor : null, sloganHidden : null, sloganOffsetX : null, sloganOffsetY : null, sloganOffsetBottomY,
    appPrivacyOne : null, appPrivacyTwo : null, appPrivacyColor : null, privacyOffsetBottomY : null, privacyOffsetX : null, privacyState : true, 
    uncheckedImgPath : null, checkedImgPath : null, checkBoxHidden : null }, timeOut = 10) {
    return RNCLShanYanSDK.quickAuthLogin(params, timeOut);
  }
```

## 登录返回说明

```javascript
//返回JSON结构
{
 code: 0,// code 等于0 是其他方式  1  是右上角关闭点击，其他code参照闪验官网
 message: "",
 data: "", // 登录返回的appid 等信息
 
}
```
