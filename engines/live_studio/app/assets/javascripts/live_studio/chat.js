(function(e) {

  var data = {};
  var nim;
  var currentTeam = {};

  function onConnect() {
    console.log('连接成功');
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
  function onMsg(msg, mark = true) {
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
    // 处理自定义消息
    $("#messages").append("<div class='talk-div'>" + msg.fromNick + " 说: " + msg.text +
      "<div class='talk-time-div'>" + sendMessageTime(msg) + "</div>" +
      "</div>");
    $("#messages").scrollTop($("#messages").prop('scrollHeight'));
  }

  function refreshTeamMembersUI(teamId) {
    //var members = data.teamMembers[teamId];
    //$.each(members, function(index){
    //    var member = members[index];
    //    console.log(member);
    //    var media = $("#media-template .media").clone();
    //    media.find("img").attr("src", "https://ruby-china-files.b0.upaiyun.com/user/big_avatar/2110.jpg");
    //    media.find(".media-body").text(member.account);
    //    console.log(media);
    //
    //    $("#members-panel").append(media);
    //});
  }

  function teamAnnouncement(announcement) {
    if(!announcement || announcement == '') announcement = "管理员很懒什么也没有留下"
    $("#notice-panel").html("<p>" + announcement + "</p>")
  }
  e.LiveChat = function(appKey) {
    this.appKey = appKey;
    this.config = function(account, token, teamId) {
      this.teamId = teamId;
      this.account = account;
      this.token = token;
      currentTeam.id = this.teamId;
    };
    this.init = function() {
      nim = this.nim = NIM.getInstance({
        db: false,
        autoMarkRead: false, // 取消自动标记已读
        // debug: true,
        appKey: this.appKey,
        account: this.account,
        token: this.token,
        onconnect: onConnect,
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
