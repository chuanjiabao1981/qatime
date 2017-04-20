module SessionsHelper
  include Qawechat::WechatHelper

  def sign_in(user, client_type = :web)
    remember_token = User.new_remember_token
    if client_type == :web
      cookies.permanent[:remember_token]      = remember_token
      cookies.permanent[:remember_user_type]  = user.role
    end
    client_type = LoginToken.client_types[client_type]
    login_token = user.login_tokens.find_or_create_by(client_type: client_type)
    login_token.remember_token = remember_token
    login_token.digest_token = User.digest(remember_token)
    login_token.save
    login_token
  end

  def sign_out
    remember_token = headers['Remember-Token'] || cookies[:remember_token]
    login_token = ::LoginToken.find_by(digest_token: User.digest(remember_token))
    if login_token.client_type == 'web'
      cookies.delete(:remember_token)
      cookies.delete(:remember_user_type)
      cookies.delete(:payment_passd_warning)
    end
    login_token.update_attributes(digest_token: User.digest(User.new_remember_token))
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
    @current_user ||= user_from_wechat
  end

  def signed_in?
    !current_user.nil?
  end

  private

  def user_from_remember_token
    remember_token = headers['Remember-Token'] || cookies[:remember_token]
    return if remember_token.blank?
    digest_token = User.digest(remember_token)
    LoginToken.find_by(digest_token: digest_token).try(:user)
  end

  def user_from_wechat
    get_user_from_wechat(params)
  end
end
