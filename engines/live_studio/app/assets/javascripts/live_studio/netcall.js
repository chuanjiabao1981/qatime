/*
 * 视频会议界面
 */

function NetcallBridge (config) {
  this.errorNode = $("#necall-error");
  this.channelName = config.channelName;
  this.user = config.user;
  this.appKey = config.appKey;
  // this.currentType = config.currentType;
  this.currentType = 'board';
  this.chatNim = config.chatNim;
}

NetcallBridge.fn = NetcallBridge.prototype;
NetcallBridge.fn.init = function () {
  this.initNetcall();
  this.fetchPlayStatus();
}

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
NetcallBridge.fn.initNetcallMeeting = function () {
  var netcall = this.netcall, that = this;
  netcall.on('joinChannel', function (obj) {
    that.onJoinChannel(obj);
  });
  netcall.on('leaveChannel', function (obj) {
    that.onLeaveChannel(obj);
  });
  netcall.initSignal().then(() => {
    this.signalInited = true;
    that.joinChannel();
  }).catch(err => {
    that.signalInited = false;
  });
};

/*
 * 初始化聊天
 */
NetcallBridge.fn.connect = function (cb) {
  var that = this;
  this.chatNim = new ChatNim({
    appKey: that.appKey,
    account: that.user.account,
    token: that.user.token,
    teamID: that.channelName,
    cb: cb
  });
  // 自定义消息订阅
  this.chatNim.subscribe('custom', that.onCustomMsg);
};

// 自定义消息处理
NetcallBridge.fn.onCustomMsg = function (msg) {
  console.log(msg);
  if (msg.data) {
    this.initNetcallMeeting();
  }
}

// 查询互动状态
NetcallBridge.fn.fetchPlayStatus = function () {
  var that = this;

  this.chatNim.nim.sendCustomMsg({
    scene: 'team',
    to: that.channelName,
    content: JSON.stringify({event: 'FetchPlayStatus'}),
    text: JSON.stringify({event: 'FetchPlayStatus'}),
    done: function () {
      console.log('正在查询直播状态');
    }
  });
};

