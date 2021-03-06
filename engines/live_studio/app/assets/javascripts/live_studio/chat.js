window.currentTeam = {
  members: {}
};

(function(e) {

  var data = {};
  var nim;

  function onConnect(fn) {
    console.log('连接成功');
    fn();
  }
  function onWillReconnect(obj) {
    // 此时说明 SDK 已经断开连接, 请开发者在界面上提示用户连接已断开, 而且正在重新建立连接
    console.log('即将重连');
    console.log(obj.retryCount);
    console.log(obj.duration);
  }
  function onDisconnect(error) {
    // 此时说明 SDK 处于断开状态, 开发者此时应该根据错误码提示相应的错误信息, 并且跳转到登录页面
    console.log('丢失连接');
    console.log(error);
    if (error) {
      switch (error.code) {
        // 账号或者密码错误, 请跳转到登录页面并提示错误
        case 302:
          break;
        // 被踢, 请提示错误后跳转到登录页面
        case 'kicked':
          break;
        default:
          break;
      }
    }
  }
  function onError(error) {
    console.log(error);
  }

  function onInvalidTeams(teams) {
    data.teams = nim.cutTeams(data.teams, teams);
    data.invalidTeams = nim.mergeTeams(data.invalidTeams, teams);
    refreshTeamsUI();
  }
  function onCreateTeam(team) {
    console.log('你创建了一个群', team);
    data.teams = nim.mergeTeams(data.teams, team);
    refreshTeamsUI();
    onTeamMembers({
      teamId: team.teamId,
      members: owner
    });
  }
  function refreshTeamsUI() {
    // 刷新界面
  }
  function onTeamMembers(obj) {
    var teamId = obj.teamId;
    var members = obj.members;
    if(teamId !== currentTeam.id) return false;
    console.log('群id', teamId, '群成员', members);
    data.teamMembers = data.teamMembers || {};
    data.teamMembers[teamId] = nim.mergeTeamMembers(data.teamMembers[teamId], members);
    data.teamMembers[teamId] = nim.cutTeamMembers(data.teamMembers[teamId], members.invalid);
    $.each(members, function(index, member) {
      if(member.account === currentTeam.account && member.mute) {
        currentTeam.mute = true;
        // 隐藏输入框并显示提示
        $("#message-div").hide().closest('form').next().show();
        // 表情输入不可用
        $("#emotion-btn").hide().next().show();

      }
    });
    refreshTeamMembersUI(teamId);
  }
  function onSyncTeamMembersDone() {
    console.log('同步群列表完成');
  }
  function onUpdateTeamMember(teamMember) {
    console.log('群成员信息更新了', teamMember);
    onTeamMembers({
      teamId: teamMember.teamId,
      members: teamMember
    });
  }
  // 漫游消息
  function onRoamingMsgs(obj) {
    if(obj.sessionId != "team-" + currentTeam.id) return false;
    $.each(obj.msgs, function(index, msg) {
      onMsg(msg, false, 'roaming');
    });
    nim.markMsgRead(currentTeamMsgs);
  }
  // 离线消息
  function onOfflineMsgs(obj) {
    console.log('收到离线消息', obj);
    if(obj.sessionId != "team-" + currentTeam.id) return false;
    $.each(obj.msgs, function(index, msg) {
      onMsg(msg, true, 'offline');
    });
    nim.markMsgRead(obj.msgs);
  }
  // 消息处理
  // marked是否已经标记为已读
  // fromType 消息来源 offline: 离线消息, roaming: 漫游消息, immediate: 即时消息
  function onMsg(msg, marked, fromType) {
    if(!fromType) fromType = 'immediate';
    // 不是该聊天组消息
    if(msg.scene != "team" || msg.to != currentTeam.id ) {
      return;
    }
    pushMsg(msg);
    switch (msg.type) {
      case 'custom':
        onCustomMsg(msg, fromType);
        break;
      case 'notification':
        // 处理群通知消息
        onTeamNotificationMsg(msg, fromType);
        $("#messages").scrollTop($("#messages").prop('scrollHeight')+120);
        break;
      case 'image':
        onImageMsg(msg, fromType);
        break;
      case 'audio':
        onAudioMsg(msg, fromType);
        break;
      default:
        onNormalMsg(msg, fromType);
        break;
    }
    if(!marked) nim.markMsgRead(msg);
  }
  function pushMsg(msgs) {
    if (!Array.isArray(msgs)) { msgs = [msgs]; }
    var sessionId = msgs[0].sessionId;
    data.msgs = data.msgs || {};
    data.msgs[sessionId] = nim.mergeMsgs(data.msgs[sessionId], msgs);
  }

  // 显示通知消息
  function onAnnouncementMsg(msg) {
    var msgNode = $("<div class='new-information'></div>");
    var announcementNode = $("<div class='announcement'></div>");
    announcementNode.append("<h6>" + msg.fromNick +  "修改了公告</h6>");
    announcementNode.append("<p>" + msg.attach.team.announcement +  "</p>");
    msgNode.append(announcementNode);
    $("#messages").append(msgNode);
  }

  function onTeams(teams) {
    console.log('收到群列表', teams);
    data.teams = nim.mergeTeams(data.teams, teams);
    $.each(data.teams, function(index, team) {
      if(team.teamId == currentTeam.id){
        if(team.announcement) teamAnnouncement(team.announcement);
        return;
      }
    });
    onInvalidTeams(teams.invalid);
  }

  function onAddTeamMembers(team, accounts, members) {
    var teamId = team.teamId;
    if(team.teamId != currentTeam.id) return false;
    /*
     如果是别人被拉进来了，那么拼接群成员列表
     如果是自己被拉进来了，那么同步一次群成员列表
     */

    $.each(members, function(index, member) {
      if(accounts.indexOf(member.account) >= 0) {
        $("#messages").append("<div class='notice-div'>" + member.nick +  " 加入了聊天组</div>");
      }
    });

    if (accounts.indexOf(data.account) === -1) {
      onTeamMembers({
        teamId: teamId,
        members: members
      });
    } else {
      nim.getTeamMembers({
        teamId: teamId,
        sync: true,
        done: function(error, obj) {
          if (!error) {
            onTeamMembers(obj);
          }
        }
      });
    }
    onTeams(team);
  }
  function onRemoveTeamMembers(team, teamId, accounts) {
    /*
     如果是别人被踢了，那么移除群成员
     如果是自己被踢了，那么离开该群
     */
    if (accounts.indexOf(data.account) === -1) {
      if (team) {
        onTeams(team);
      }
      data.teamMembers[teamId] = nim.cutTeamMembersByAccounts(data.teamMembers[teamId], teamId, accounts);
      refreshTeamMembersUI();
    } else {
      leaveTeam(teamId);
    }
  }


  // 系统消息
  function onTeamNotificationMsg(msg) {
    // 处理群通知消息
    var type = msg.attach.type,
      from = msg.from,
      teamId = msg.to,
      timetag = msg.time,
      team = msg.attach.team,
      account = msg.attach.account,
      accounts = msg.attach.accounts,
      members = msg.attach.users || msg.attach.members;

    console.log(type);
    switch (type) {
      case 'updateTeam':
        team.updateTime = timetag;
        if(msg) onAnnouncementMsg(msg);
        onTeams(team);
        break;
      case 'addTeamMembers':
        onAddTeamMembers(team, accounts, members);
        break;
      case 'removeTeamMembers':
        onRemoveTeamMembers(team, teamId, accounts);
        break;
      case 'acceptTeamInvite':
        onAddTeamMembers(team, [from], members);
        break;
      case 'passTeamApply':
        onAddTeamMembers(team, [account], members);
        break;
      case 'addTeamManagers':
        updateTeamManagers(teamId, members);
        break;
      case 'removeTeamManagers':
        updateTeamManagers(teamId, members);
        break;
      case 'leaveTeam':
        onRemoveTeamMembers(team, teamId, [from]);
        break;
      case 'dismissTeam':
        dismissTeam(teamId);
        break;
      case 'transferTeam':
        transferTeam(team, members);
        break;
      case 'updateTeamMute':
        updateTeamMute(msg.attach, members);
        break;
    }
  }

  // 禁言或解除禁言后输入框设置
  function muteMessage(mute) {
    currentTeam.mute = mute;
    if(mute) {
      // 隐藏输入框并显示提示
      $("#message-div").hide().closest('form').next().show();
      // 表情输入不可用
      $("#emotion-btn").hide().next().show();
    } else {
      // 显示输入框并隐藏提示
      $("#message-div").show().closest('form').next().hide();
      // 表情输入可用
      $("#emotion-btn").show().next().hide();
    }
  }

  function updateTeamMute(obj, members) {
    $.each(members, function(index, member) {
      var tip = obj.mute ? " 被禁言" : " 被解除禁言";
      if(member.account == obj.account) {
        $("#messages").append("<div class='notice-div'>" + member.nick + tip + "</div>");
      }
    });
    // 自己被禁言
    if(obj.account === currentTeam.account) muteMessage(obj.mute);
  }

  function onNormalMsg(msg, fromType) {
    appendMsg(msg, null, fromType);
  }

  function onCustomMsg(msg, fromType) {
    appendMsg(msg, 'Custom', fromType);
  }

  function onImageMsg(msg) {
    appendMsg(msg, 'Image');
    $("#messages").scrollTop($("#messages").prop('scrollHeight')+180);
  }

  function onAudioMsg(msg) {
    appendMsg(msg, 'Audio');
    $("#messages").scrollTop($("#messages").prop('scrollHeight')+180);
  }

  function teamAnnouncement(announcement) {
    if(!announcement || announcement == ''){
      $("#announcement-empty").show();
    }else{
      $("#announcement-empty").hide();
    };
    $("#notice-content").text(announcement);
    // refreshNotice();
  }

  window.LiveChat = function(appKey) {
    this.appKey = appKey;
    this.config = function(account, token, teamId, owner) {
      this.teamId = teamId;
      this.account = account;
      this.token = token;
      currentTeam.id = this.teamId;
      currentTeam.owner = owner;
      currentTeam.account = account;
    };
    this.setBarrage = function(barrage) {
      console.log('------>>>>>>>>');
      console.log(currentTeam);
      console.log(barrage);

      currentTeam.barrage = barrage;
    };
    this.init = function(fn) {
      nim = this.nim = NIM.getInstance({
        db: false,
        autoMarkRead: false, // 取消自动标记已读
        // debug: true,
        appKey: this.appKey,
        account: this.account,
        token: this.token,
        onconnect: onConnect(fn),
        onwillreconnect: onWillReconnect,
        ondisconnect: onDisconnect,
        onerror: onError,
        onteams: onTeams,
        onsynccreateteam: onCreateTeam,
        onteammembers: onTeamMembers,
        onsyncteammembersdone: onSyncTeamMembersDone,
        onupdateteammember: onUpdateTeamMember,
        // 消息
        onroamingmsgs: onRoamingMsgs,
        onofflinemsgs: onOfflineMsgs,
        onmsg: onMsg
      });
    };
    this.refreshTeamsUI = function() {
      return refreshTeamsUI();
    }
    this.refreshTeamMembersUI = function (teamId) {
      return refreshTeamMembersUI(teamId);
    };
    this.pushMsg = function (msgs) {
      return pushMsg(msgs);
    };
  }
})(this);

//判断flash是否安装方法
function flashChecker(){
  var hasFlash=0;　　　　//是否安装了flash
  var flashVersion=0;　　//flash版本

  if(document.all){
    var swf = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
    if(swf) {
      hasFlash=1;
      VSwf=swf.GetVariable("$version");
      flashVersion=parseInt(VSwf.split(" ")[1].split(",")[0]);
    }
  } else {
    if(navigator.plugins && navigator.plugins.length > 0) {
      var swf=navigator.plugins["Shockwave Flash"];
      if(swf) {
        hasFlash=1;
        var words = swf.description.split(" ");
        for(var i = 0; i < words.length; ++i) {
          if (isNaN(parseInt(words[i]))) continue;
          flashVersion = parseInt(words[i]);
        }
      }
    }
  }
  return {f:hasFlash,v:flashVersion};
}

function refreshTeamMembersUI(teamId, fn) {
  if(teamId != currentTeam.id) return;
  $.get('/chat/teams/' + teamId + '/members',function(data){
    $("#members-panel").html(data);
    if(fn) fn();
  });
}


function sendMessageTime(msg, type){
  var date = new Date(msg.time);
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
}

// 消息标签
function messageTag(msg, fromType) {
  var messageNode = $("<div class='information-con'></div>");
  switch (msg.type) {
    // 通知消息
    case 'notification':
      console.log('notification messages', msg);
      messageNode.append($.replaceChatMsg(msg.text));
      break;
    // 图片消息
    case 'image':
      var messageGroup = 'chat-team-' + currentTeam.id;
      if(fromType === 'roaming') messageGroup = 'chat-team-histories' + currentTeam.id;
      var imageNode = $('<a class="fancybox-buttons" data-fancybox-group="' + messageGroup + '" href="' + msg.file.url + '"><img class="accept-img" src="' + msg.file.url + '" /></a>');
      imageNode.one("load", function() {
        $("#messages").scrollTop($("#messages").prop('scrollHeight')+120);
      });
      messageNode.append(imageNode);
      break;
    // 音频消息
    case 'audio':
      var mp3Url = live_chat.nim.audioToMp3({url: msg.file.url});
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
      break;
    case 'custom':
      messageNode.append(customMessageItem(msg));
    default:
      messageNode.append($.replaceChatMsg(msg.text));
      break;
  }
  return messageNode;
}

// 自定义消息
function customMessageItem(msg) {
  var message = JSON.parse(msg.content);
  var messageNode;  
  switch (message.type) {
  case 'LiveStudio::ScheduledLesson':
    messageNode = liveMessage(msg);
    break;
  case 'LiveStudio::InstantLesson':
    messageNode = liveMessage(msg);
    break;
  case 'LiveStudio::Question':
    messageNode = taskMessage(msg);
    break;
  case 'LiveStudio::Answer':
    messageNode = taskMessage(msg);
    break;
  case 'LiveStudio::Homework':
    messageNode = taskMessage(msg);
    break;
  case 'LiveStudio::Correction':
    messageNode = taskMessage(msg);
    break;
  case 'Resource::File':
    messageNode = taskMessage(msg);
    break;
  default:
    messageNode = liveMessage(msg);
    break;
  }
  return messageNode;
}

var TaskTypes = {
  "LiveStudio::Question": '问题',
  "LiveStudio::Answer": '问题',
  "LiveStudio::Homework": '作业',
  "LiveStudio::Correction": '批改',
  "Resource::File": '课件'
};

// 任务消息
function taskMessage(msg) {
  var message = JSON.parse(msg.content);
  var messageNode = messageItem(msg);
  var messageClass = message.type.replace(/([A-Z])/g,"_$1").replace('_Live_Studio::_', '').replace('_Resource::_', '').toLowerCase();
  if(message.event === 'create') {
    messageNode.append(messageTitle(msg, messageNode));
    var messageBody = $("")
    messageBody = $("<div class='information-con'></div>");
    messageLink = $("<a href='/live_studio/customized_groups/" + message.taskable_id + "' class='folders' target='_blank'></a>");
    messageLink.append('<span class="folders-title folders-' + messageClass + '">' + TaskTypes[message.type] + '</span>');
    messageLink.append('<span class="folders-info">' + message.title + '</span>');
    messageBody.append(messageLink);
    messageNode.append(messageBody);
  }
  return messageNode;
}

var LiveMessages = {
  "LiveStudio::ScheduledLesson": {
    start: "直播开始",
    close: "直播结束"
  },
  "LiveStudio::InstantLesson": {
    start: "老师开启了互动答疑",
    close: "老师关闭了互动答疑"
  }
};

// 直播消息
function liveMessage(msg) {
  var message = JSON.parse(msg.content);
  var messageNode = messageItem(msg);
  var text = "未知消息";
  if(LiveMessages[message.type] && LiveMessages[message.type][message.event]) {
    text = LiveMessages[message.type][message.event];
  }
  messageNode.append("<div class='announcement'><h6>" + text + "</h6></div>");
  return messageNode;
}

// 消息节点
function messageItem(msg) {
  return $("<div class='new-information' id='msg-" + msg.idClient + "'></div>");
}

// 消息头
function messageTitle(msg, messageNode) {
  var dom = $("<div class='information-title'></div>");
  dom.append("<img src='' class='information-title-img'>");
  if(msg.from == currentTeam.account){
    dom.append("<span class='information-name'>" + msg.fromNick + "(我)</span>");
    messageNode.addClass("new-information-stu");
  } else if(msg.from == currentTeam.owner) {
    dom.append("<span class='information-name'>" + msg.fromNick + "(老师)</span>");
  } else {
    dom.append("<span class='information-name'>" + msg.fromNick + "</span>");
    messageNode.addClass("new-information-else");
  }
  dom.append(" <span class='information-time'>" + sendMessageTime(msg) + "</span>");
  return dom;
}

function appendMsg(msg, messageClass, fromType) {
  if(!messageClass) messageClass = '';
  // 显示直播开始通知
  if(messageClass == 'Custom'){
    var messageNode = customMessageItem(msg);
    $("#messages").append(messageNode);
    $("#messages").scrollTop($("#messages").prop('scrollHeight')+120);
    return;
  } else {
    var messageNode = messageItem(msg);
  }

  // 消息标题 老师 发送时间
  var messageTitle = $("<div class='information-title'></div>");
  messageTitle.append("<img src='' class='information-title-img'>");

  if(msg.from == currentTeam.account){
    messageTitle.append("<span class='information-name'>" + msg.fromNick + "(我)</span>");
    messageNode.addClass("new-information-stu");
  } else if(msg.from == currentTeam.owner) {
    messageTitle.append("<span class='information-name'>" + msg.fromNick + "(老师)</span>");
  } else {
    messageTitle.append("<span class='information-name'>" + msg.fromNick + "</span>");
    messageNode.addClass("new-information-else");
  }
  messageTitle.append(" <span class='information-time'>" + sendMessageTime(msg) + "</span>");
  messageNode.append(messageTitle);
  // 消息内容标签
  var messageContent = messageTag(msg, fromType);
  messageNode.append(messageContent);

  $("#messages").append(messageNode);

  var itemId = messageNode.attr('id');
  $("#" + itemId + " .weixinAudio").weixinAudio();

  // 显示弹幕
  if(messageClass != 'Image' && currentTeam.barrage.active && fromType != 'offline' && fromType != 'roaming') {
    if(msg.type !== 'audio') currentTeam.barrage.show($.replaceChatMsg(msg.text));
  }

  $("#messages").scrollTop($("#messages").prop('scrollHeight')+120);

  if($("#member-icons").find("img.icon-" + msg.from).size() > 0) {
    $("#msg-" + msg.idClient).find(".information-title img").attr("src", $("#member-icons").find("img.icon-" + msg.from).attr("src"));
  } else {
    refreshTeamMembersUI(currentTeam.id, function() {
      $("#msg-" + msg.idClient).find(".information-title img").attr("src", $("#member-icons").find("img.icon-" + msg.from).attr("src"));
    });
  }
}

$(function() {
  // 聊天tab切换
  $(".message-title a").click(function  () {
    var index = $(".message-title a").index($(this));
    $(this).addClass('message-content active').siblings().removeClass('message-content active');
    $('.message-con').eq(index).show().siblings().hide();
  });

  // 清空聊天消息
  $("#clear-btn").click(function() {
    $("#messages").empty();
  });


  function submitCounter() {
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
  }

  // 聊天输入区域
  $("#message-form").submit(function() {
    if(!chatInited) return false;
    if(currentTeam.mute) {
      // 隐藏输入框并显示提示
      $("#message-div").hide().closest('form').next().show();
      // 表情输入不可用
      $("#emotion-btn").hide().next().show();
      return false;
    }
    if($("#message-form :submit").hasClass('pendding')) return false;
    $("#message-form :submit").addClass("pendding");
    $("#message-form :submit").attr("disabled", true);
    submitCounter();
    msg = $("#message-area").val().trim().replace(/\</g, '&lt;').replace(/\>/g, '&gt;');

    if(msg === '') return false;
    var msg = live_chat.nim.sendText({
      scene: 'team',
      to: live_chat.teamId,
      text: msg,
      done: sendMsgDone
    });

    console.log('正在发送p2p text消息, id=' + msg.idClient);
    $("#message-area").val("");
    live_chat.pushMsg(msg);
    return false;
  });

  // 回车提交表单
  $('#message-area').keydown(function(event) {
    if (event.keyCode === 13 && !event.shiftKey) {
      $('#message-form').submit();
      return false;
    }
  });

  // 消息发送回调
  function sendMsgDone(error, msg) {
    appendMsg(msg, ' new-information-stu', 'local');
    live_chat.pushMsg(msg);
  }

});
