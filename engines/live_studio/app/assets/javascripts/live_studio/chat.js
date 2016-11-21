window.currentTeam = {};

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
    console.log('群id', teamId, '群成员', members);
    data.teamMembers = data.teamMembers || {};
    data.teamMembers[teamId] = nim.mergeTeamMembers(data.teamMembers[teamId], members);
    data.teamMembers[teamId] = nim.cutTeamMembers(data.teamMembers[teamId], members.invalid);
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
    console.log('收到漫游消息', obj);

    currentTeamMsgs = $.grep(obj.msgs, function(index, msg) {
      console.log(index);
      console.log(msg);
      return msg.type == "team" && msg.to == currentTeam.id;
    });

    $.each(currentTeamMsgs, function(index, msg) {
      onMsg(msg, false);
    });
    nim.markMsgRead(currentTeamMsgs);
  }
  // 离线消息
  function onOfflineMsgs(obj) {
    console.log('收到离线消息', obj);
    if(obj.sessionId != "team-" + currentTeam.id) return false;

    $.each(obj.msgs, function(index, msg) {
      onMsg(msg, false);
    });
    nim.markMsgRead(obj.msgs);
  }
  // 消息处理
  function onMsg(msg, mark) {
    console.log('收到消息', msg.scene, msg.type, msg);
    // 不是该聊天组消息
    if(msg.scene != "team" || msg.to != currentTeam.id ) {
      console.log(msg.scene != "team");
      console.log(currentTeam.id);
      console.log(msg.to);
      console.log(msg.to != currentTeam.id);
      return;
    }
    pushMsg(msg);
    switch (msg.type) {
      case 'custom':
        break;
      case 'notification':
        // 处理群通知消息
        onTeamNotificationMsg(msg);
        break;
      default:
        onNormalMsg(msg)
        break;
    }
    if(mark) nim.markMsgRead(msg);
  }
  function pushMsg(msgs) {
    console.log(msgs);
    if (!Array.isArray(msgs)) { msgs = [msgs]; }
    var sessionId = msgs[0].sessionId;
    data.msgs = data.msgs || {};
    data.msgs[sessionId] = nim.mergeMsgs(data.msgs[sessionId], msgs);
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
        $("#messages").append("<div class='notice-div'>" + member.nick +  " 加入了聊天组</div>")
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

    switch (type) {
      case 'updateTeam':
        team.updateTime = timetag;
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
    }
  }

  function onNormalMsg(msg) {
    appendMsg(msg);
  }

  function teamAnnouncement(announcement) {
    if(!announcement || announcement == '') announcement = "管理员很懒什么也没有留下"
    $("#notice-panel").html("<p>" + announcement + "</p>")
  }

  window.LiveChat = function(appKey) {
    this.appKey = appKey;
    this.config = function(account, token, teamId, owner) {
      this.teamId = teamId;
      this.account = account;
      this.token = token;
      currentTeam.id = this.teamId;
      currentTeam.owner = owner;
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

function appendMsg(msg, messageClass) {
  if(!messageClass) messageClass = '';
  // 处理自定义消息
  var messageItem = $("<div class='new-information" + messageClass + "' id='msg-" + msg.idClient + "'></div>");
  // 消息标题 老师 发送时间
  var messageTitle = $("<div class='information-title'></div>");
  messageTitle.append("<img src='' class='information-title-img'>");

  if(msg.from != currentTeam.account){
    messageTitle.append("<span class='information-name'>" + msg.fromNick + "</span>");
  }
  messageTitle.append("<span class='information-time'>" + sendMessageTime(msg) + "</span>");
  messageItem.append(messageTitle);
  // 消息内容
  var messageContent = $("<div class='information-con'>" + $.replaceChatMsg(msg.text) + "</div>");
  messageItem.append(messageContent);


  if(msg.from == currentTeam.account){
    messageItem.addClass("new-information-stu");
  } else if(msg.from != currentTeam.owner) {
    messageItem.addClass("new-information-else");
  }
  $("#messages").append(messageItem);



  $("#messages").scrollTop($("#messages").prop('scrollHeight'));

  if($("#member-icons").find("img.icon-" + msg.from).size() > 0) {
    $("#msg-" + msg.idClient).find(".information-title img").attr("src", $("#member-icons").find("img.icon-" + msg.from).attr("src"));
  } else {
    refreshTeamMembersUI(currentTeam.id, function() {
      $("#msg-" + msg.idClient).find("img").attr("src", $("#member-icons").find("img.icon-" + msg.from).attr("src"));
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

  // 聊天输入区域
  $("#message-form").submit(function() {
    if(!chatInited) return false;
    msg = $("#message-area").val().trim().replace(/\</g, '&lt;').replace(/\>/g, '&gt;');;

    if(msg == '') return false;
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

  // 输入换行
  $('#message-area').keydown(function() {
    var message = $(this).val();
    if (event.keyCode == 13) {
      if (message == "") {
        // alert("Enter Some Text In Textarea");
      } else {
        $('#message-form').submit();
      }
      $("#message-area").val('');
      return false;
    }
  });

  // 消息发送回调
  function sendMsgDone(error, msg) {
    appendMsg(msg, ' new-information-stu');
    live_chat.pushMsg(msg);
  }
});
