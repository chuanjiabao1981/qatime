/*
 * 聊天界面
 */


(function(e) {
  var defaultContainers = {
    messages: "#messages",
    histories: "#histories",
    barrage: "#barrage",
    members: '#members-panel',
    announcements: '#notice-panel',
    tab: '#chat-tab a',
    msgSend: '#message-form'
  };

  var chatUI;
  function ChatQatimeUI (chatNim, options) {
    this.chatNim = chatNim;
    this.nim = chatNim.nim;
    this.containers = options.containers || defaultContainers;
    this.bindEvent();
    this.initEvent();
    this.onTeamMembers();
  }

  window.ChatQatimeUI = ChatQatimeUI;

  ChatQatimeUI.fn = ChatQatimeUI.prototype;

  // 事件绑定
  ChatQatimeUI.fn.bindEvent = function () {
    chatUI = this;
    // 聊天消息
    this.chatNim.subscribe('chat', 'text', this.onChat);
    this.chatNim.subscribe('chat', 'image', this.onChat);
    this.chatNim.subscribe('chat', 'audio', this.onChat);
    // 弹幕消息
    this.chatNim.subscribe('chat', 'text', this.onBarrage);
    // 历史消息
    this.chatNim.subscribe('history', 'text', this.onHistory);
    this.chatNim.subscribe('history', 'image', this.onHistory);
    this.chatNim.subscribe('history', 'audio', this.onHistory);
  };

  // 事件绑定
  ChatQatimeUI.fn.initEvent = function () {
    var that = this;
    this.initTabEvent();
    this.initSendMsgEvent();
    this.initBarrage();
    this.initToolBar();
  };

  // 聊天tab切换
  ChatQatimeUI.fn.initTabEvent = function () {
    var that = this;
    $(that.containers['tab']).click(function  () {
      var index = $(that.containers['tab']).index($(this));
      $(this).addClass('message-content active').siblings().removeClass('message-content active');
      $('.message-con').eq(index).show().siblings().hide();
    });
  };

  // 发送聊天消息事件
  ChatQatimeUI.fn.initSendMsgEvent = function () {
    var that = this;
    // 聊天输入区域
    $(that.containers['msgSend']).submit(function() {
      console.log('11111');
      // 聊天消息发送检查
      if(!that.chatNim.sendMsgCheck($("#message-area"), $("#message-form :submit"))) return false;
      // 添加发送中样式
      $("#message-form :submit").addClass("pendding");
      $("#message-form :submit").attr("disabled", true);
      that.sendMsgCounter();
      msg = $("#message-area").val().trim().replace(/\</g, '&lt;').replace(/\>/g, '&gt;');

      if(msg === '') return false;
      var msg = that.chatNim.sendMsg(msg, function (msg) {
        console.log(msg);
      });
      $("#message-area").val('');
      return false;
    });

    // 回车提交表单
    $('#message-area').keydown(function(event) {
      if (event.keyCode === 13 && !event.shiftKey) {
        $('#message-form').submit();
        return false;
      }
    });

  };

  // 弹幕
  ChatQatimeUI.fn.initBarrage = function () {
    this.chatNim.subscribe('chat', 'text', this.onBarrage);
  };

  // 工具条
  ChatQatimeUI.fn.initToolBar = function () {
    var that = this;
    // 聊天表情
    $("#emotion-btn").qqFace({ assign: "message-area", path: "/assets/face/" }, function() {
      $("#message-area").focus();
    });
    // 清空聊天消息
    $("#clear-btn").click(function() {
      $("#messages").empty();
    });

    // 历史消息
    $('#history-btn').click(function(event) {
      // TODO
      alert('暂不支持历史记录');
      return false;
      $("#histories").show();
      that.chatNim.loadHistoryMessages();
    });

    $("#history-close").click(function() {
      $("#histories").hide();
    });
  };

  ChatQatimeUI.fn.sendMsgCounter = function () {
    var counter = 2;
    var submitText = $("#message-form :submit").val();
    $("#message-form :submit").val("(" + counter + "s)");
    var chatTimer = setInterval(function() {
      counter = counter - 1;
      $("#message-form :submit").val("(" + counter + "s)");
      if(counter <= 0) {
        clearInterval(chatTimer);
        $("#message-form :submit").removeClass("pendding");
        $("#message-form :submit").removeAttr("disabled");
        $("#message-form :submit").val(submitText);
      }
    }, 1000);
  };

  // 弹幕消息
  ChatQatimeUI.fn.onBarrage = function (msg) {
    // TODO 暂时不支持弹幕
  };

  // 聊天消息
  ChatQatimeUI.fn.onChat = function (msg) {
    var container = $(chatUI.containers['messages']);
    if(!container) return false;
    container.append(chatUI.messageTag(msg));
    chatUI.nim.markMsgRead(msg);
  };

  // 群组成员变动
  ChatQatimeUI.fn.onTeamMembers = function () {
    var members = this.chatNim.members;
    var container = $(chatUI.containers['members']);
    container.empty();
    $.each(members, function(index, member) {
      var node = $("<div class='new-information'></div>");
      var titleNode = $("<div class='information-title'></div>");
      titleNode.append("<img src='" + member.avatar + "' class='information-title-img' /> ");
      titleNode.append("<span class='information-user'>" + member.nickname + "</span> ");
      titleNode.append("<span class='information-category'>" + member.role + "</span>");
      node.append(titleNode);
      container.append(node);
    });
  };

  // 获取群组成员
  ChatQatimeUI.fn.getMembers = function (done) {
    var that = this;
    if(!this.teamMembersUrl) this.teamMembersUrl = qatimeConfig.teamMembersUrl.replace(':team_id', this.teamID);
    $.getJSON(this.teamMembersUrl, function(result) {
      that.chatNim.publish('ui', { type: 'members', members: result.members });
      if(done) done(result.members);
    });
  };

  // 消息标签
  ChatQatimeUI.fn.messageTag = function (msg, options) {
    console.log(789);
    console.log(msg);
    var tag = '';
    switch (msg.type) {
      case 'text':
        tag = this.textMsgTag(msg, options);
        break;
      case 'notification':
        // 处理群通知消息
        tag = this.notificationMsgTag(msg, options);
        break;
      case 'image':
        tag = this.imageMsgTag(msg, options);
        break;
      case 'audio':
        tag = this.audioMsgTag(msg, options);
        break;
      default:
        break;
    }
    return tag;
  };

  // 时间格式化
  function formatTime (t, type){
    var date = new Date(t);
    var hours = date.getHours();
    var minutes = "0" + date.getMinutes();
    var seconds = "0" + date.getSeconds();
    if(type == "long"){
      var year = date.getFullYear();
      var month = date.getMonth() + 1;
      var date = date.getDate();
      return year + "-" + month + "-" + date + " " + hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2)
    }
    else{
      return hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2)
    }
  };

  // 聊天内容格式化
  function formatMsgContent (content) { 
    return $.replaceChatMsg(content);
  }

  // 用户头像
  function accountAvatar (account) {
    var member = chatUI.chatNim.members[account];
    if (member ) return member.avatar;
  }

  // 用户昵称
  function magicNickname (msg) {
    var member = chatUI.chatNim.members[msg.from];
    if (msg.from == chatUI.chatNim.account) {
      return msg.fromNick + " (我)";
    } else if (member && member.role == 'teacher') {
      return msg.fromNick + " (老师)";
    }
    return msg.fromNick;
  } 

  // 消息标题
  ChatQatimeUI.fn.messageTitleTag = function (msg) {
    var titleTag = $("<div class='information-title'></div>");
    titleTag.append("<img src='" + accountAvatar(msg.from) + "' /> ");
    titleTag.append("<span class='information-name'>" + magicNickname(msg) + "</span> ");
    titleTag.append("<span class='information-time'>" + formatTime(msg.time) + "</span></div>");
    return titleTag;
  };

  // 图片消息
  ChatQatimeUI.fn.imageMsgTag = function (msg) {
    var tag = $('<div class="new-information" id="msg-' + msg.idClient + '"></div>');
    tag.append(this.messageTitleTag(msg)); // 消息头
    var messageTag = $("<div class='information-con'></div>");
    var imageNode = $('<img class="accept-img" src="' + msg.file.url + '">');
    imageNode.one("load", function() {
      $("#messages").scrollTop($("#messages").prop('scrollHeight')+120);
    });
    messageTag.append(imageNode);
    messageTag.append(messageTag);
    return tag;
  };

  // 语音消息
  ChatQatimeUI.fn.audioMsgTag = function (msg) {
    var tag = $('<div class="new-information" id="msg-' + msg.idClient + '"></div>');
    tag.append(this.messageTitleTag(msg)); // 消息头
    var messageNode = $("<div class='information-con'></div>");
    var mp3Url = this.chatNim.nim.audioToMp3({url: msg.file.url});
    var audioNode = $('<p class="weixinAudio"></p>');
    audioNode.append('<audio src="' + mp3Url + '" class="media"></audio>');
    var audioSpan = '<span  class="db audio_area">';
    var audioSecond = parseInt((parseInt(msg.file.dur) + 500) / 1000);
    // 记录音频时长
    audioNode.attr('audio-second', audioSecond);
    audioSpan = audioSpan + '<span class="audio_wrp db">';
    audioSpan = audioSpan + '<span class="audio_play_area">';
    audioSpan = audioSpan + '<i class="icon_audio_default"></i>';
    audioSpan = audioSpan + '<i class="icon_audio_playing"></i>';
    audioSpan = audioSpan + '</span>';
    audioSpan = audioSpan + '</span>';
    audioSpan = audioSpan + '<span class="audio_length tips_global"></span>';
    // 本地消息和漫游消息不显示未读标记
    if(fromType !== 'roaming' && fromType !== 'local') audioSpan = audioSpan + '<span class="unlisten"></span>';
    audioSpan = audioSpan + '</span>';
    audioNode.append(audioSpan);
    messageNode.append(audioNode);
    var audio = audioNode.weixinAudio();
    audio.updateTotalTime();
    messageTag.append(messageNode);
    return tag;
  }

  // 文字消息
  ChatQatimeUI.fn.textMsgTag = function (msg) {
    var tag = $('<div class="new-information" id="msg-' + msg.idClient + '"></div>');
    tag.append(this.messageTitleTag(msg)); // 消息头
    tag.append("<div class='information-con'>" + formatMsgContent(msg.text) + "</div>"); // 消息体
    return tag;
  };

  // 通知消息
  ChatQatimeUI.fn.notificationMsgTag = function (msg) {
    // TODO
  }
})(this);
