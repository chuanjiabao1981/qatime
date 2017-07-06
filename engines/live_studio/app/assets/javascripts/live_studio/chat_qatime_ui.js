/*
 * 聊天界面
 */


(function(e) {
  var defaultContainers = {
    messages: "#messages",
    histories: "#histories",
    barrage: "#barrage"
  };

  var chatUI;
  function ChatQatimeUI (chatNim, options) {
    this.chatNim = chatNim;
    this.nim = chatNim.nim;
    this.containers = options.containers || defaultContainers;
    this.members = {};
    this.bindEvent();
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
    // 群成员变动
    this.chatNim.subscribe('ui', 'members', this.onTeamMembers);
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
  ChatQatimeUI.fn.onTeamMembers = function (msg) {
    var members = msg.members;
    that.chatNim.members = result.members;
    that.refreshTeamsUI();
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
    var member = chatUI.members[account];
    if (member ) return member.avatar;
  }

  // 用户昵称
  function magicNickname (msg) {
    var member = chatUI.members[msg.from];
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
    console.log(1222222);
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
