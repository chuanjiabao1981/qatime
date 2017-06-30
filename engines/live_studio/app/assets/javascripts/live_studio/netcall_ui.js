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
  var obj = this.teacherObj;
  this.netcall.setVideoViewRemoteSize({ account: obj.account, width: 164, height: 122 });
  // 白板互动时视频画面切换到摄像头位置
  obj.node = document.getElementById('teacher-camera-area');
  this.showBoardTips();
  this.playVideo(this.teacherObj);
}

/*
 * 切换到桌面互动
 */
NetcallBridge.fn.switchToDesktop = function () {
  var obj = this.teacherObj;
  this.netcall.setVideoViewRemoteSize({ account: obj.account, width: 1036, height: 583 });
  // 桌面互动时视频画面切换到白板位置
  obj.node = document.getElementById('teacher-board-area');
  this.showDesktopTips();
  this.playVideo(obj);
}

/*
 * 显示学生画面
 */
NetcallBridge.fn.showStudent = function (obj) {
  obj.node = document.getElementById('student-camera-area');
  this.netcall.setVideoViewRemoteSize({ width: 164, height: 122 });
  this.playVideo(obj);
}

/*
 * 视频播放开始
 */
NetcallBridge.fn.playVideo = function (obj) {
  var that = this;
  that.netcall.startDevice({
    type: Netcall.DEVICE_TYPE_AUDIO_OUT_CHAT
  }).catch(function () {
    that.log('播放对方的声音失败')
  });
  this.netcall.startRemoteStream(obj);
}

/*
 * 白板互动提示
 */
NetcallBridge.fn.showBoardTips = function () {

}

/*
 * 屏幕共享提示
 */
NetcallBridge.fn.showDesktopTips = function () {

}
