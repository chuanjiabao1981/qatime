/*
 * 视频会议
 */
var fn = NetcallBridge.fn;
NetcallBridge.timer = null;

/*
 * 加入音视频房间
 */
NetcallBridge.fn.joinChannel = function (done, fail) {
  var that = this;
  this.netcall.joinChannel({
    type: Netcall.DEVICE_TYPE_VIDEO,
    channelName: that.channelName, // 必填
    custom: { // 自定义字段
      role: that.user.role
    },
    sessionConfig: {}
  }).then(function (obj) { // 加入成功
    that.signalInited = true;
    console.log('joinChannel', obj);
    done();
  }).catch(function (err) { // 加入错误
    that.signalInited = false;
    console.log('joinChannelError', err);
    that.showError("加入房间错误");
    fail(err);
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
  this.showTeacher(obj);
};

// 显示参与者画面
NetcallBridge.fn.memberJoin = function (obj) {
  this.showStudent(obj);
};

NetcallBridge.fn.onLeaveChannel = function (obj) {

};

// 判断是否主播
NetcallBridge.fn.isTeacher = function (account) {
  return this.teachers.indexOf(account) >= 0;
}

// 判断是否参与者
NetcallBridge.fn.isMember = function (account) {
  return this.teachers.indexOf(account) < 0;
}

// 互动状态切换
NetcallBridge.fn.statusSwitch = function (status) {
  this.status = status;
  if(status == 'teaching') {
    this.switchToTeaching();
    return true;
  } else if (status == 'paused') {
    this.switchToPause();
  } else {
    this.switchToStop();
  }
  // 互动结束以后开始轮训状态
  this.fetchPlayStatus();
};

// 直播状态
NetcallBridge.fn.switchToTeaching = function () {
  var that = this;
  that.initNetcallMeeting(function() {
  }, function(error) {
    console.log(error);
  });
};

// 暂停状态
NetcallBridge.fn.switchToPause = function () {

};

// 未开始状态
NetcallBridge.fn.switchToStop = function () {

};

// 设置老师
NetcallBridge.fn.setTeachers = function (accounts) {
  this.teachers = accounts;
}

// 查询互动状态
NetcallBridge.fn.fetchPlayStatus = function () {
  var that = this;
  if(!this.playStatusUrl) this.playStatusUrl = qatimeConfig.teamStatusUrl.replace(':team_id', this.channelName);
  $.getJSON(this.playStatusUrl, function(result) {
    // 如果播放状态不一致切换播放状态
    if(that.status != result.live_info.status) {
      that.statusSwitch(result.live_info.status);
      clearInterval(NetcallBridge.timer);
    } else {
      // 定时查询互动状态
      if (!NetcallBridge.timer) {
        NetcallBridge.timer = setInterval(function () {
          that.fetchPlayStatus();
        }, 5 * 1000);
      }
    }
  });
};
