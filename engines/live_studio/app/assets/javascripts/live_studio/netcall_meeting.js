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
    sessionConfig: {
      videoQuality: Netcall.CHAT_VIDEO_QUALITY_480P,
      videoFrameRate: Netcall.CHAT_VIDEO_FRAME_RATE_NORMAL,
      videoBitrate: 0,
      recordVideo: false,
      recordAudio: false,
      highAudio: false
    }
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
  var box = this.boxOf(account);
  box.addClass('loading');
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
  if (this.isTeacher(obj.account)) { // 直播结束
    this.switchToStop();
  } else { // 关闭摄像头画面
    var box = this.boxOf(account);
    box.find('canvas').hide();
    box.removeClass('loading');
  }
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
  } else if (status == 'paused') {
    this.switchToPause();
  } else {
    this.switchToStop();
  }
  // 互动结束以后开始轮训状态
  // this.fetchPlayStatus();
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
  this.netcall.leaveChannel().then(function() {
    if(!NetcallBridge.timer) this.fetchPlayStatus();
  });
};

// 设置老师
NetcallBridge.fn.setTeachers = function (accounts) {
  this.teachers = accounts;
};

NetcallBridge.fn.onMeetingControl = function (obj) {
  var account = obj.account;
  var members = this.chatNim.members;
  if (!members[account]) return;

  switch (obj.type) {
    // NETCALL_CONTROL_COMMAND_NOTIFY_AUDIO_ON 通知对方自己打开了音频
    case Netcall.NETCALL_CONTROL_COMMAND_NOTIFY_AUDIO_ON:
      this.log("对方打开了麦克风");
      break;
    // NETCALL_CONTROL_COMMAND_NOTIFY_AUDIO_OFF 通知对方自己关闭了音频
    case Netcall.NETCALL_CONTROL_COMMAND_NOTIFY_AUDIO_OFF:
      this.log("对方关闭了麦克风");
      break;
    // NETCALL_CONTROL_COMMAND_NOTIFY_VIDEO_ON 通知对方自己打开了视频
    case Netcall.NETCALL_CONTROL_COMMAND_NOTIFY_VIDEO_ON:
      this.log("对方打开了摄像头");
      this.nodeLoadingStatus(obj.account, '');
      this.nodeCameraStatus(obj.account, true);
        break;
    // NETCALL_CONTROL_COMMAND_NOTIFY_VIDEO_OFF 通知对方自己关闭了视频
    case Netcall.NETCALL_CONTROL_COMMAND_NOTIFY_VIDEO_OFF:
      this.log("对方关闭了摄像头");
      this.nodeLoadingStatus(obj.account, '对方关闭了摄像头');
      this.nodeCameraStatus(obj.account, false);
      break;
    // NETCALL_CONTROL_COMMAND_SWITCH_AUDIO_TO_VIDEO_REJECT 拒绝从音频切换到视频
    case Netcall.NETCALL_CONTROL_COMMAND_SWITCH_AUDIO_TO_VIDEO_REJECT:
      this.log("对方拒绝从音频切换到视频通话");
      break;
    // NETCALL_CONTROL_COMMAND_SWITCH_AUDIO_TO_VIDEO 请求从音频切换到视频
    case Netcall.NETCALL_CONTROL_COMMAND_SWITCH_AUDIO_TO_VIDEO:
      this.log("对方请求从音频切换到视频通话");
      break;
    // NETCALL_CONTROL_COMMAND_SWITCH_AUDIO_TO_VIDEO_AGREE 同意从音频切换到视频
    case Netcall.NETCALL_CONTROL_COMMAND_SWITCH_AUDIO_TO_VIDEO_AGREE:
      this.log("对方同意从音频切换到视频通话");
      break;
    // NETCALL_CONTROL_COMMAND_SWITCH_VIDEO_TO_AUDIO 从视频切换到音频
    case Netcall.NETCALL_CONTROL_COMMAND_SWITCH_VIDEO_TO_AUDIO:
      this.log("对方请求从视频切换为音频");
      break;
    // NETCALL_CONTROL_COMMAND_BUSY 占线
    case Netcall.NETCALL_CONTROL_COMMAND_BUSY:
      this.log("对方正在通话中");
      this.log("取消通话");
      this.nodeLoadingStatus(obj.account, '对方正在通话中');
      break;
    // NETCALL_CONTROL_COMMAND_SELF_CAMERA_INVALID 自己的摄像头不可用
    case Netcall.NETCALL_CONTROL_COMMAND_SELF_CAMERA_INVALID:
      this.log("对方摄像头不可用");
      this.nodeLoadingStatus(obj.account, '对方摄像头不可用');
      this.nodeCameraStatus(obj.account, false);
      break;
  }

};

// 查询互动状态
NetcallBridge.fn.fetchPlayStatus = function () {
  console.log("=====>>>获取直播状态");
  var that = this;
  if(!this.playStatusUrl) this.playStatusUrl = qatimeConfig.teamStatusUrl.replace(':team_id', this.channelName);
  $.getJSON(this.playStatusUrl, function(result) {
    // 如果播放状态不一致切换播放状态
    if(that.status != result.live_info.status) {
      clearInterval(NetcallBridge.timer);
      that.statusSwitch(result.live_info.status);
    } else if (!NetcallBridge.timer) {
      NetcallBridge.timer = setInterval(function() {
        that.fetchPlayStatus();
      }, 5 * 1000);
    }
  });
};

NetcallBridge.fn.nodeLoadingStatus = function (account, message) {
  var box = this.boxOf(account);
  box.removeClass('loading').find('.tip').html(message || '');
};

NetcallBridge.fn.nodeCameraStatus = function (account, isEnable) {
  isEnable = isEnable || false;
  var box = this.boxOf(account);
  box.find('canvas').toggleClass('hide', !isEnable);
}

NetcallBridge.fn.boxOf = function (account) {
  if(this.isTeacher(account)) {
    return $("#teacher-area");
  } else {
    return $("#student-area");
  }
};
