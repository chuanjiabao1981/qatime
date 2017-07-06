/*
 * 聊天封装
 */


(function(e) {
  var chatNim;

  function ChatHandler () {
  }
  ChatHandler.fn = ChatHandler.prototype;

  // 链接完成回调
  ChatHandler.fn.onConnect = function () {
    chatNim.chatInited = true;
    chatNim.done();
  };

  // 收到消息
  ChatHandler.fn.onMsg = function (msg) {
    // 非本群组消息不处理
    if (!validMsg(msg)) return false;
    // 消息分发
    chatNim.publish('chat', msg);
  }

  // 离线消息
  ChatHandler.fn.onOfflineMsgs = function (obj) {
    // 不是本群组离线消息
    if (!validMsg(obj)) return false;
    $.each(obj.msgs, function(index, msg) {
      chatNim.publish('offline', msg.type, msg);
    });
  };

  // 漫游消息
  ChatHandler.fn.onRoamingMsgs = function (obj) {
    // 不是本群组离线消息
    if (!validMsg(obj)) return false;
    $.each(obj.msgs, function(index, msg) {
      this.chatNim.publish('offline', msg.type, msg);
    });
  };

  // 历史消息
  ChatHandler.fn.onHistoryMsgs = function (obj) {
    // 不是本群组离线消息
    if (!validMsg(obj)) return false;
    $.each(obj.msgs, function(index, msg) {
      this.chatNim.publish('offline', msg.type, msg);
    });
  };

  // 消息发送结束回调
  ChatHandler.fn.sendMsgDone = function (error, msg) {
    chatNim.handlers.onMsg(msg);
  };

  function ChatQatime (config) {
    this.appKey = qatimeConfig.chat.appKey;
    this.account = config.account;
    this.token = config.token;
    this.teamID = config.teamID;
    this.subscribers = {};
    this.done = config.done;
    this.handlers = new ChatHandler(this);
    this.members = config.members;
    this.init();
  }
  window.ChatQatime = ChatQatime;
  ChatQatime.fn = ChatQatime.prototype;

  ChatQatime.fn.init = function () {
    var that = this;
    chatNim = window.chatNim = this;
    window.nim = chatNim.nim = NIM.getInstance({
      // debug: true,
      appKey: chatNim.appKey,
      account: chatNim.account,
      token: chatNim.token,
      db: false,
      autoMarkRead: false, // 取消自动标记已读
      onconnect: this.handlers.onConnect,
      onwillreconnect: this.handlers.onWillReconnect,
      ondisconnect: this.handlers.onDisconnect,
      onerror: function(error) {
        console.log(error);
      },
      onteams: this.handlers.onTeams,
      onsynccreateteam: this.handlers.onCreateTeam,
      onteammembers: this.handlers.onTeamMembers,
      onsyncteammembersdone: this.handlers.onSyncTeamMembersDone,
      onupdateteammember: this.handlers.onUpdateTeamMember,
      // 消息
      onroamingmsgs: this.handlers.onRoamingMsgs,
      onofflinemsgs: this.handlers.onOfflineMsgs,
      onmsg: this.handlers.onMsg
    });
  };

  ChatQatime.fn.sendMsgCheck = function (msgArea, penddingArea) {
    // 聊天未初始
    if(!this.chatInited) return false;
    // 被禁言
    if(this.mute && msgArea) {
      msgArea.val("").attr("placeholder", "您被禁言了").attr("disabled", true);
      return false;
    }
    // 正在发送消息
    return !penddingArea.hasClass('pendding');
  };

  // 消息发送
  ChatQatime.fn.sendMsg = function (content) {
    var that = this;
    this.nim.sendText({
      scene: 'team',
      to: this.teamID,
      text: content,
      done: that.handlers.sendMsgDone
    });
  };


  // 是否本群组消息
  function validMsg (obj) {
    if(obj.sessionId) return "team-" + chatNim.teamID == obj.sessionId;
    return obj.scene == "team" && obj.to == chatNim.teamID;
  };

  /*
   * 消息订阅
   * from 消息来源
   *   chat: 聊天消息
   *   offline: 离线消息
   *   roaming: 漫游消息
   *   history: 历史消息
   * type 消息类型
   *   text: 文本消息
   *   image: 图片消息
   *   audio: 音频消息
   *   video: 视频消息
   *   file: 文件消息
   *   geo: 地理位置消息
   *   custom: 自定义消息
   *   tip: 提醒消息
   *   notification: 群通知消息
   */
  ChatQatime.fn.subscribe = function (from, type, subscriber) {
    var key = from + "-" + type;
    if(!this.subscribers[key]) this.subscribers[key] = [];
    this.subscribers[key].push(subscriber);
  };

  /*
   * 消息分发
   * from 消息来源
   *   chat: 聊天消息
   *   offline: 离线消息
   *   roaming: 漫游消息
   *   history: 历史消息
   */
  ChatQatime.fn.publish = function (from, msg) {
    var type = msg.type;
    var key = from + "-" + type;
    var subscribers = chatNim.subscribers[key];
    if(!subscribers || subscribers.length <= 0) return;
    $.each(subscribers, function(i, subscriber) {
      subscriber(msg, from);
    });
  };
})(this);
