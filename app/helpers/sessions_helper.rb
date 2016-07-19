module SessionsHelper
  include Qawechat::WechatHelper
  def sign_in(user, client_type)
    remember_token = User.new_remember_token
    if client_type == :web
      cookies.permanent[:remember_token]      = remember_token
      cookies.permanent[:remember_user_type]  = user.role
      # user.update_attribute(:remember_token, User.digest(remember_token))
    end

    user.create_login_token(
      remember_token: User.digest(remember_token),
      client_type: client_type
    )
    current_user = user
  end
  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    cookies.delete(:remember_user_type)
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
    remember_token = User.digest(cookies[:remember_token])
    user_type = cookies[:remember_user_type]

    if cookies[:remember_user_type] == 'student'
      Student.find_by(remember_token: remember_token) unless remember_token.nil?
    elsif cookies[:remember_user_type] == 'teacher'
      Teacher.find_by(remember_token: remember_token) unless remember_token.nil?
    elsif cookies[:remember_user_type] == 'admin'
      Admin.find_by(remember_token: remember_token) unless remember_token.nil?
    elsif cookies[:remember_user_type] == 'manager'
      Manager.find_by(remember_token: remember_token) unless remember_token.nil?
    elsif user_type == 'waiter'
      Waiter.find_by(remember_token: remember_token) unless remember_token.nil?
    elsif user_type == 'seller'
      Seller.find_by(remember_token: remember_token) unless remember_token.nil?
    end
  end

  def user_from_wechat
    get_user_from_wechat(params)
  end

end
