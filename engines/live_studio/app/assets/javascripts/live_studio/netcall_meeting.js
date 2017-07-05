/*
 * 视频会议
 */
var fn = NetcallBridge.fn;
NetcallBridge.timer = null;

/*
 * 加入音视频房间
 */
NetcallBridge.fn.joinChannel = function () {
  var that = this;
  this.netcall.joinChannel({
    type: Netcall.DEVICE_TYPE_VIDEO,
    channelName: that.channelName, // 必填
    custom: { // 自定义字段
      role: that.user.role
    },
    sessionConfig: {}
  }).then(obj => { // 加入成功
    that.signalInited = true;
    console.log('joinChannel', obj);
  }).catch(err => { // 加入错误
    that.signalInited = false;
    console.log('joinChannelError', err);
    that.showError("加入房间错误");
  });
};

NetcallBridge.fn.onJoinChannel = function (obj) {
  if (this.isTeacher(obj.account)) { // 主播
    this.teacherJoin(obj);
  } else if (this.isMember(obj.account)) { // 参与者
    this.memberJoin(obj);
  }
};

// 显示主播画面
NetcallBridge.fn.teacherJoin = function (obj) {
  this.teacherObj = obj;
  if (this.currentType == 'board') {
    this.switchToBoard();
  } else {
    this.switchToDesktop();
  }
};

// 显示参与者画面
NetcallBridge.fn.memberJoin = function (obj) {
  this.showStudent(obj);
};

NetcallBridge.fn.onLeaveChannel = function (obj) {

};

// 判断是否主播
NetcallBridge.fn.isTeacher = function (account) {
  return true;
}

// 判断是否参与者
NetcallBridge.fn.isMember = function (account) {
  return true;
}

// 开始互动
NetcallBridge.fn.start = function () {
  var that = this;
  that.initNetcallMeeting(function() {

  }, function(err) {
    // 加入失败以后两秒后轮训互动状态
    setTimeout(function() {
      that.fetchPlayStatus();
    }, 2 * 1000);
  });
};

// 查询互动状态
NetcallBridge.fn.fetchPlayStatus = function () {
  var that = this;
  if(!this.playStatusUrl) this.playStatusUrl = "/live_studio/teams/" + channelName + "/status";
  $.getJSON(this.playStatusUrl, function(result) {
    if (result.status == 'playing') {
      clearInterval(NetcallBridge.timer);
      NetcallBridge.timer = null;
      that.start();
    } else if (!NetcallBridge.timer) {
      NetcallBridge.timer = setInterval(function () {
        that.fetchPlayStatus();
      }, 5 * 1000);
    }
  });
};
