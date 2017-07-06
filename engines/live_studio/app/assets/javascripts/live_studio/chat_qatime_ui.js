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
    // 弹幕消息
    this.chatNim.subscribe('chat', 'text', this.onBarrage);
  };

  // 事件绑定
  ChatQatimeUI.fn.initEvent = function () {
    var that = this;
    this.initTabEvent();
    this.initSendMsgEvent();
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
    // TODO
    // chatUI.containers('barrage').append(this.messageTag(msg));
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
    // TODO
  };

  // 语音消息
  ChatQatimeUI.fn.audioMsgTag = function (msg) {
    // TODO
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
