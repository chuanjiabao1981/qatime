/*
 * 视频会议界面
 */

function NetcallBridge (config) {
  this.errorNode = $("#necall-error");
  this.channelName = config.channelName;
  this.user = config.user;
  this.appKey = qatimeConfig.chat.appKey;
  // this.currentType = config.currentType;
  this.currentType = 'board';
  this.chatNim = config.chatNim;
}

NetcallBridge.fn = NetcallBridge.prototype;
NetcallBridge.fn.init = function () {
  this.initNetcall();
  this.fetchPlayStatus();
};

/*
 * 初始化音视频
 */
NetcallBridge.fn.initNetcall = function () {
  var that = this;
  NIM.use(Netcall);

  var netcall = this.netcall = Netcall.getInstance({
    nim: window.nim,
    mirror: false,
    mirrorRemote: false,
    /*kickLast: true,*/
    container: $(".netcall-video-local")[0],
    remoteContainer: $(".netcall-video-remote")[0]
  });
}

/*
 * 初始化多人音视频
 */
NetcallBridge.fn.initNetcallMeeting = function (done, fail) {
  var netcall = this.netcall, that = this;
  netcall.on('joinChannel', function (obj) {
    that.onJoinChannel(obj);
  });
  netcall.on('leaveChannel', function (obj) {
    that.onLeaveChannel(obj);
  });
  netcall.initSignal().then(() => {
    this.signalInited = true;
    that.joinChannel(done, fail);
  }).catch(err => {
    that.signalInited = false;
    if (fail) fail(err);
  });
};

/*
 * 初始化聊天
 */
NetcallBridge.fn.connect = function (cb) {
  var that = this;
  console.log('1222222');
  if (this.chatNim) {
    cb();
  } else {
    this.chatNim = new ChatQatime({
      appKey: that.appKey,
      account: that.user.account,
      token: that.user.token,
      teamID: that.channelName,
      cb: cb
    });
  }
};

