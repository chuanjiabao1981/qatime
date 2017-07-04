/*
 * 聊天封装
 */


(function(e) {
  var chatNim;
  function ChatQatime (config) {
    this.appKey = config.appKey;
    this.account = config.account;
    this.token = config.token;
    this.teamID = config.teamID;
    this.subscribers = {};
    this.init(config.done);
  }
  window.ChatQatime = ChatQatime;
  ChatQatime.fn = ChatQatime.prototype;

  ChatQatime.fn.init = function (cb) {
    chatNim = window.chatNim = this;
    window.nim = chatNim.nim = NIM.getInstance({
      // debug: true,
      appKey: chatNim.appKey,
      account: chatNim.account,
      token: chatNim.token,
      db: false,
      autoMarkRead: false, // 取消自动标记已读
      onconnect: cb,
      onwillreconnect: chatNim.onWillReconnect,
      ondisconnect: chatNim.onDisconnect,
      onerror: chatNim.onError,
      onteams: chatNim.onTeams,
      onsynccreateteam: chatNim.onCreateTeam,
      onteammembers: chatNim.onTeamMembers,
      onsyncteammembersdone: chatNim.onSyncTeamMembersDone,
      onupdateteammember: chatNim.onUpdateTeamMember,
      // 消息
      onroamingmsgs: chatNim.onRoamingMsgs,
      onofflinemsgs: chatNim.onOfflineMsgs,
      onmsg: chatNim.onMsg
    });
  };

  // 聊天消息处理
  ChatQatime.fn.onMsg = function (msg) {
    // 非本群组消息不处理
    if (!validMsg(msg)) return false;
    // 消息分发
    chatNim.publish('chat', msg);
  };

  // 离线消息
  ChatQatime.fn.onOfflineMsgs = function (obj) {
    // 不是本群组离线消息
    if (!validMsg(obj)) return false;
    $.each(obj.msgs, function(index, msg) {
      chatNim.publish('offline', msg.type, msg);
    });
  };

  // 漫游消息

  // 历史消息

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
