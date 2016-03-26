// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
  
var voice = {
  localId: '',
  serverId: ''
};

document.querySelector('#startRecord').onclick = function () {
  wx.startRecord({
    cancel: function () {
      alert('用户拒绝授权录音');
    }
  });
};

document.querySelector('#stopRecord').onclick = function () {
  wx.stopRecord({
    success: function (res) {
      voice.localId = res.localId;
    },
    fail: function (res) {
      alert(JSON.stringify(res));
    }
  });
};

document.querySelector('#playVoice').onclick = function () {
  if (voice.localId == '') {
    alert('请先录制一段声音，再点击播放');
    return;
  }
  wx.playVoice({
    localId: voice.localId
  });
};

document.querySelector('#uploadVoice').onclick = function () {
  if (voice.localId == '') {
    alert('请先录制一段声音，再点击上传');
    return;
  }
  wx.uploadVoice({
    localId: voice.localId,
    success: function (res) {
      //alert('上传语音成功，serverId 为' + res.serverId);
      voice.serverId = res.serverId;
      var options = {
        serverId: res.serverId
      }
      $.post("http://rails.wrcomputer.cn/qawechat/wechat_voice",
      options,
      function(data,status){
    	alert("Data: " + data + "\nStatus: " + status);
      });
    }
  });
};

