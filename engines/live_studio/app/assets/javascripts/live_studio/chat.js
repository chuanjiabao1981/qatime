(function(e) {
  var data = {};
  var nim;

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


  function onTeams(teams) {
      console.log('收到群列表', teams);
      data.teams = nim.mergeTeams(data.teams, teams);
      onInvalidTeams(teams.invalid);
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
  function onRoamingMsgs(obj) {
      console.log('收到漫游消息', obj);
      pushMsg(obj.msgs);
  }
  function onOfflineMsgs(obj) {
      console.log('收到离线消息', obj);
      pushMsg(obj.msgs);
  }
  function onMsg(msg) {
      console.log('收到消息', msg.scene, msg.type, msg);
      pushMsg(msg);
      onCustomMsg(msg);
  }
  function pushMsg(msgs) {
    console.log(msgs);
      if (!Array.isArray(msgs)) { msgs = [msgs]; }
      var sessionId = msgs[0].sessionId;
      data.msgs = data.msgs || {};
      data.msgs[sessionId] = nim.mergeMsgs(data.msgs[sessionId], msgs);
  }
  function onCustomMsg(msg) {
    // 处理自定义消息
    $("#messages").append("<div>" + msg.fromNick + "说: " + msg.text + "</div>");
  }

  function onTeamNotificationMsg(msg) {
    // 系统消息处理
    $("#messages").append("<div>" + msg + "</div>");
  }

  function refreshTeamMembersUI(teamId) {
    var members = data.teamMembers[teamId];
    $.each(members, function(index){
      var member = members[index];
      console.log(member);
      var media = $("#media-template .media").clone();
      media.find("img").attr("src", "https://ruby-china-files.b0.upaiyun.com/user/big_avatar/2110.jpg");
      media.find(".media-body").text(member.account);
      console.log(media);

      $("#members-panel").append(media);
    });
  }
  e.LiveChat = function(appKey) {
    this.appKey = appKey;
    this.config = function(account, token, team_id) {
      this.team_id = team_id;
      this.account = account;
      this.token = token;
    };
    this.init = function() {
      nim = this.nim = NIM.getInstance({
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