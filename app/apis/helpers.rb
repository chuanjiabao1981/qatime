require 'will_paginate/array'

module APIHelpers
  extend ActiveSupport::Concern
  include VersionsHelper

  # 认证管理员
  def staffer_authenticate!
    # 如果token不存在，则返回没有得到token
    raise APIErrors::NoGetAuthenticate unless request.headers["Authorization"].present?
    raise APIErrors::AuthenticateFail unless current_staffer
  end

  # 认证用户
  def authenticate!
    # 如果token不存在，则返回没有得到token
    raise APIErrors::NoGetAuthenticate unless request.headers["Authorization"].present?
    raise APIErrors::AuthenticateFail unless current_user
  end

  def verify_p2p_account!
    raise APIErrors::VeriftyFail, "还未开通i操盘账户" unless current_user.p2p_account_exists?
  end

  def verify_user_certification!
    raise APIErrors::VeriftyFail, "还未绑定手机号" unless current_user.mobile.present?
    raise APIErrors::VeriftyFail, "还未进行实名认证" unless current_user.certification_exists?
  end

  # 在接口执行之前进行统计工作
  def extend_callback
    # 记录用户活跃度
    current_user.try(:sign_user_active)
  rescue
    raise unless Rails.env.production?
  end

  # 设备的sn码
  def sn_code
    @header_sn_code ||= headers["X-Sn-Code"]
  end

  def setup_token(user, attr={})
    attr.merge!(sn_code: sn_code, device: client_version)
    user.make_token(attr)

    UserLoginLog.app_login!(user, attr.slice(:sn_code, :device).merge(ip: ip))
  end

  def ip
    headers["X-Real-Ip"] || env['REMOTE_ADDR']
  end

  def current_staffer
    @current_staffer ||= begin
      header_token = request.headers["Authorization"]

      token = ApiStafferToken.where(access_token: header_token, sn_code: sn_code).first

      # 如果token存在并且没有过期
      if token && !token.expired?
        # 如果临近过期时间，推迟过期时间
        token.refresh_expires_at! if token.expires_at - Time.now <= 3.days
        token.staffer
      else
        nil
      end
    end
  end

  def current_user
    @current_user ||= begin
      header_token = request.headers["Authorization"]

      token = ApiToken.where(access_token: header_token, sn_code: sn_code).first

      # 如果token存在并且没有过期
      if token && !token.expired?
        # 如果临近过期时间，推迟过期时间
        token.refresh_expires_at! if token.expires_at - Time.now <= 3.days
        # 如果device和这次请求的device不一致，更新device记录
        token.update(device: client_version) if token.device != client_version
        token.user
      else
        nil
      end
    end
  end

  # 对客户端提交的未正确进行UTF-8编码的数据进行编码
  def normalize_encode_params
    @env["rack.request.form_hash"] ||= {}
    encode_params_values params if request.form_data? && request.media_type == 'multipart/form-data'
  end

  # 迭代对 params 的 values 进行编码处理
  def encode_params_values(hash)
    return if hash.blank?
    hash.each do |k, v|
      if hash[k].is_a?(Hash)
        encode_params_values(hash[k])
      else
        hash[k].force_encoding(Encoding::UTF_8).encode! if hash[k].is_a?(String)
      end
    end
  end

  def paginate(objs)
    return objs unless objs.respond_to? :paginate
    total_entries = objs.count > 1000 ? 1000 : objs.count
    objs.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10, total_entries: total_entries)
  end

  def present(data, options={})
    # 如果不是get请求并且能够reload，就执行reload保证数据同步更新
    data.reload if (!request.get?) && data.respond_to?(:reload)
    options.merge!(current_user: current_user) if current_user.present?

    is_paging = data.respond_to?(:total_pages)

    if is_paging
      super :per_page, data.per_page
      super :page, data.current_page
      super :total_pages, data.total_pages
      super :total_entries, data.total_entries
    end

    # 扩展n+1相关查询数据
    expand_data(data)

    if data == true
      data = 1
    elsif data == false
      data = 0
    end

    is_paging ? super(:data, data, options) : super(data, options)
  end

  def expand_data(data)
    #User.expand_users(data) if [User::ActiveRecord_Relation, User::ActiveRecord_AssociationRelation].include? data.class
  end

  def dup_params(opts={})
    params.dup.tap do |p|
      p.delete :format
      p.merge!(
        user_terminal_info: sn_code,
        user_terminal_ip: ip,
      )
      p.merge!(opts)
    end.each_with_object({}){|(k,v), memo| memo[k.to_sym] = v}.merge('X-Client-IP' => ip)
  end

  # Etag
  def compare_etag(max_age=0, etag_key="", etag_match=params.map{|k,v| "#{k}:#{v}"}.join("-"))
    etag = etag_key + etag_match
    etag = "W/\"#{Digest::SHA1.hexdigest(etag)}\""

    header "Cache-control", "max-age=#{max_age}, private, must-revalidate"

    if request.headers["If-None-Match"] == etag
      error!("Not Modified", 304)
    end

    header "ETag", etag
  end

  def setup_request
    if !Rails.env.production? and defined?(RequestStore)
      RequestStore.store[:ip] ||= ip
    end
  end

  def date_result_limit(data, begin_date, end_date, count)
    if begin_date.present? && count.present? && end_date.blank?
      data.first(count)
    elsif end_date.present? && count.present? && begin_date.blank?
      data.last(count)
    else
      data
    end
  end
end
