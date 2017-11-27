require 'will_paginate/array'
require_relative './helpers/versions_helper'
require_relative '../helpers/sessions_helper'

module APIHelpers
  extend ActiveSupport::Concern
  include VersionsHelper
  include SessionsHelper

  # 认证用户
  def authenticate!
    # 如果token不存在，提示未登录
    raise APIErrors::NotLogin unless request.headers["Remember-Token"].present?
    # 找不到current_user，提示授权过期
    raise APIErrors::AuthenticateExpired unless current_user
    raise APIErrors::NoVisitPermission unless allow?
  end

  def client_ip
    headers['X-Real-Ip'] || env["REMOTE_ADDR"]
  end

  # 根据日期查询记录
  def query_by_date(chain)
    chain = chain.where("created_at > ?", params[:start_date].to_date) if params[:start_date].present?
    chain = chain.where("created_at <= ?", params[:end_date].to_date + 1) if params[:end_date].present?
    chain
  rescue
    chain
  end

  # 检查客户端
  def check_client!(user, client_cate)
    soft = ::Software.published.where(category: ::Software.categories[client_cate]).last
    raise APIErrors::ClientInvalid unless soft.present? && soft.role == user.role
  end

  def current_permission
    @current_permission ||= Permissions.permission_for(current_user)
  end

  def auth_params
  end

  # 权限认证
  def allow?
    current_permission.api_allow?(request.request_method, request.path, auth_params)
  end

  def ip
    headers["X-Real-Ip"] || env['REMOTE_ADDR']
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

  # def present(data, options={})
  #   # 如果不是get请求并且能够reload，就执行reload保证数据同步更新
  #   data.reload if (!request.get?) && data.respond_to?(:reload)
  #   options.merge!(current_user: current_user) if current_user.present?

  #   is_paging = data.respond_to?(:total_pages)

  #   if is_paging
  #     super :per_page, data.per_page
  #     super :page, data.current_page
  #     super :total_pages, data.total_pages
  #     super :total_entries, data.total_entries
  #   end

  #   # 扩展n+1相关查询数据
  #   expand_data(data)

  #   if data == true
  #     data = 1
  #   elsif data == false
  #     data = 0
  #   end

  #   is_paging ? super(:data, data, options) : super(data, options)
  # end

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

  def raise_change_error_for(flag)
    !flag && raise(APIErrors::StatusChangeError)
  end
end
