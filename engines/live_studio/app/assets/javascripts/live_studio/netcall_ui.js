/*
 * 视频会议界面
 */
var fn = NetcallBridge.fn;

/*
 * 显示错误提示
 */
NetcallBridge.fn.showError = function (msg) {
  this.errorNode.text(msg).show();
};

/*
 * 检查平台支持情况
 */
NetcallBridge.fn.checkPlatform = function (done, failure) {
  failure = failure || function () { };
  if (platform.os.family.indexOf("Windows") !== -1 && (platform.os.version === "10" || platform.os.version === "7")) { // 判断是否是win7或win10
    if (platform.name === "Chrome" || platform.name === "Microsoft Edge" || (platform.name === "IE" && platform.version === "11.0")) { // 判断是否是Chrome, Edge, IE 11
      done();
    } else {
      showError('当前浏览器不支持音视频功能，请使用 Chrome、IE 11 或者 Edge 浏览器');
      failure();
    }
  } else {
    showError('当前系统不支持音视频功能，请使用win7、win10系统');
    failure();
  }
};

/*
 * 切换到白板互动
 */
NetcallBridge.fn.switchToBoard = function () {

}

/*
 * 切换到桌面互动
 */
NetcallBridge.fn.switchToDesktop = function () {

}
