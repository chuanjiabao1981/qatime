module Chat
  class IM
    IM_HOST = 'https://api.netease.im'.freeze
    cattr_accessor :app_key, :app_secret

    def self.config(conf)
      self.app_key = conf['app_key']
      self.app_secret = conf['app_secret']
    end

    def self.team_create(params)
      params = { magree: 0, joinmode: 2 }.merge(params)
      result = post_request("/team/create.action", params)
      result['tid'] if result
    end

    def self.team_add(tid, owner, msg, members)
      members = members.to_s if members.is_a?(Array)
      params = { magree: 0, tid: tid, owner: owner, msg: msg, members: members }
      post_request("/team/add.action", params)
    end

    # 解散群
    def self.team_remove(tid, owner)
      params = { tid: tid, owner: owner }
      post_request("/team/remove.action", params)
    end

    def self.team_kick(tid, owner, member)
      params = { tid: tid, owner: owner, member: member }
      post_request("/team/kick.action", params)
    end

    def self.team_query(tid, ope = 1)
      params = { tids: [tid].to_s, ope: ope }
      result = post_request("/team/query.action", params)
      result['tinfos'][0] if result
    end

    def self.team_update(params)
      post_request("/team/update.action", params)
    end

    # 创建云信ID
    def self.account_create(accid, name, icon, token = nil)
      params = { accid: accid, name: name, icon: icon }
      params[:token] = token if token.present?
      result = post_request("/user/create.action", params)
      return unless result
      return result['info'] if result['code'] == 200 || result['status'] == 200
      # 已经存在刷新
      update_or_refresh(accid, token) if result['desc'] == 'already register'
    end

    def self.update_or_refresh(accid, token = nil)
      token ? update_account(accid, token) : refresh_token(accid)
    end

    # 云信ID更新
    def self.update_account(accid, token)
      params = { accid: accid, token: token }
      post_request("/user/update.action", params)
      params
    end

    # 更新并获取新token
    def self.refresh_token(accid)
      params = { accid: accid }
      result = post_request("/user/refreshToken.action", params)
      result['info'] if result
    end

    # 更新用户名片
    def self.update_uinfo(accid, name, icon)
      params = { accid: accid, name: name, icon: icon }
      post_request("/user/updateUinfo.action", params)
    end

    # 获取用户名片
    def self.get_uinfo(accid)
      params = { accids: [accid].to_s }
      result = post_request("/user/getUinfos.action", params)
      if result['code'] == 200

        result = result['uinfos'][0]
        result.delete('gender')
        return result
      end
    end

    # 禁言群成员
    def self.mute_tlist(tid, owner, accid, mute = 1)
      params = { tid: tid, owner: owner, accid: accid, mute: mute }

      result = post_request("/team/muteTlist.action", params)
      result['code'] == 200
    end

    private_class_method

    def self.post_request(uri, body)
      res = Typhoeus.post("#{IM_HOST}/nimserver#{uri}", headers: headers, body: body)
      Rails.logger.info(res.body) if res.success?
      return JSON.parse(res.body) if res.success?
      Rails.logger.error("云信服务器通信错误\n#{uri}\n#{body}")
      nil
    end

    def self.headers
      nonce = SecureRandom.hex 16
      cur_time = Time.now.utc.to_i.to_s
      check_sum = Digest::SHA1.hexdigest(Chat::IM.app_secret + nonce + cur_time)
      {
        AppKey: Chat::IM.app_key,
        Nonce: nonce,
        CurTime: cur_time,
        CheckSum: check_sum,
        'Content-Type' => "application/x-www-form-urlencoded;charset=utf-8"
      }
    end
  end
end
