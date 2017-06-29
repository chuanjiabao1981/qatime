/*
 * 视频会议
 */
var fn = NetcallBridge.fn;

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
  if (obj.role == 'teacher') { // 主播

  } else if (obj.role == 'member') { // 参与者

  }
  console.log('开始播放', obj);
  obj.node = document.getElementById('board-area');
  this.netcall.setVideoViewRemoteSize({ width: 640, height: 480 });
  this.netcall.startRemoteStream(obj);
};

NetcallBridge.fn.onLeaveChannel = function (obj) {

};
