
'use strict'

const { NativeModules, Image, Platform } = require('react-native');


type CALL_BBACK_PROPS = {
  code: string, // 200 为正常 其他为异常
  uri: string, // 文件路径
  base64: string, // 图片base64 png
}

let RNCLShanYanSDK = undefined;

/**
 * 创蓝 闪验RN SDK
 */
export default class RNCLShanYanSDKUtil  {

  

  /**
   * @param appId 闪验appID
   * @param appKey 闪验appKey
   * @param timeOut 超时时间，单位s，传大于0有效，传小于等于0使用默认，默认10s
   * 建议在app启动时调用
   * 必须在一键登录前至少调用一次
   * 只需调用一次，多次调用不会多次初始化，与一次调用效果一致
   */
  static initWithAppId ({appId, appKey, timeOut}) {
    if (!RNCLShanYanSDK) {
      RNCLShanYanSDK = NativeModules.RNCLShanYanSDK;
    }
    return RNCLShanYanSDK.initWithAppId(appId, appKey, timeOut);
  }

  /**
   * 预取号（获取临时凭证）
   * 建议在判断当前用户属于未登录状态时使用，已登录状态用户请不要调用该方法
   * >>>> 接口作用
   * 电信、联通、移动预取号 :初始化成功后，如果当前为电信/联通/移动，将调用预取号，
   * 可以提前获知当前用户的手机网络环境是否符合一键登录的使用条件，成功后将得到用于
   * 一键登录使用的临时凭证，默认的凭证有效期60s(电信)/30min(联通)/60min(移动)。
   * >>>> 使用场景
   * 建议在执行一键登录的方法前，提前一段时间调用此方法，比如调一键登录的vc的
   * viewdidload中，或者rootVC的viewdidload中，或者app启动后，此调用将有助于
   * 提高闪验拉起授权页的速度和成功率。
   * 不建议调用后立即调用拉起授权页方法（此方法是异步）
   * 此方法需要1~2s的时间取得临时凭证，因此也不建议和拉起授权页方法一起串行调用
   * 不建议频繁的多次调用和在拉起授权页后调用
   * 建议在判断当前用户属于未登录状态时使用，已登录状态用户请不要调用该方法
   */
  static preGetPhonenumber() {
    return RNCLShanYanSDK.preGetPhonenumber();
  }

  /**
   * 
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

  static closeLogin() {
    return RNCLShanYanSDK.closeLogin();
  }

 
}

/**
 * resolve 图片资源
 * @param {String | Number} asset
 */
export const resolveImageAsset = asset => {
  switch (typeof asset) {
    case 'number':
      const result = Image.resolveAssetSource(asset)
      if (result && result.__packager_asset) return result.uri
      break
    case 'string':
      return asset
  }
  return null
}