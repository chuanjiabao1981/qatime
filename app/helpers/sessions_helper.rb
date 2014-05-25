module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token]      = remember_token
    cookies.permanent[:remember_user_type]  = user.role
    user.update_attribute(:remember_token, User.digest(remember_token))
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
  end

  def signed_in?
    !current_user.nil?
  end

  private
  def user_from_remember_token
    remember_token = User.digest(cookies[:remember_token])

    if cookies[:remember_user_type] == 'student'
      Student.find_by(remember_token: remember_token) unless remember_token.nil?
    elsif cookies[:remember_user_type] == 'teacher'
      Teacher.find_by(remember_token: remember_token) unless remember_token.nil?
    elsif cookies[:remember_user_type] == 'admin'
      Admin.find_by(remember_token: remember_token) unless remember_token.nil?
    end
  end
end
