module SessionsHelper
  include Qawechat::WechatHelper

  def sign_in(user, client_type = :web)
    remember_token = User.new_remember_token
    if client_type == :web
      cookies.permanent[:remember_token]      = remember_token
      cookies.permanent[:remember_user_type]  = user.role
    end

    login_token = user.login_tokens.find_or_create_by(client_type: client_type)
    login_token.update_attribute(:remember_token, User.digest(remember_token))

    current_user = user
  end

  def sign_out(client_type = :web)
    if client_type == :web
      cookies.delete(:remember_token)
      cookies.delete(:remember_user_type)
    end
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
    digest_token = headers['Remember-Token'] || User.digest(cookies[:remember_token])

    LoginToken.find_by(remember_token: digest_token).user
  end

  def user_from_wechat
    get_user_from_wechat(params)
  end
end
