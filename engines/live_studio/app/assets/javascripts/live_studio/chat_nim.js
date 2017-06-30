/*
 * 视频会议界面
 */

var chatNim;

function ChatNim (config) {
  this.appKey = config.appKey;
  this.account = config.account;
  this.token = config.token;
  this.teamID = config.teamID;
  this.subscribers = {};
  this.init(config.cb);
}

ChatNim.fn = ChatNim.prototype;
ChatNim.fn.init = function (cb) {
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

// 消息处理
ChatNim.fn.onMsg = function (msg) {
  console.log(msg);
  // 非本群组消息不处理
  if (msg.scene != "team" || msg.to != chatNim.teamID) return;
  // 消息分发
  chatNim.publish(msg.type, msg);
};

// 离线消息
ChatNim.fn.onOfflineMsgs = function (obj) {
  // 不是本群组离线消息
  if(obj.sessionId != "team-" + chatNim.teamID) return false;
  $.each(obj.msgs, function(index, msg) {
    chatNim.onMsg(msg);
  });
  console.log(msg);
};

// 消息订阅
ChatNim.fn.subscribe = function (type, subscriber) {
  if(!this.subscribers[type]) this.subscribers[type] =  [];
  this.subscribers[type].push(subscriber);
};

// 消息分发
ChatNim.fn.publish = function (type, msg) {
  var subscribers = chatNim.subscribers[type];
  if(!subscribers || subscribers.length <= 0) return;
  $.each(subscribers, function(i, subscriber) {
    subscriber(msg);
  });
};
