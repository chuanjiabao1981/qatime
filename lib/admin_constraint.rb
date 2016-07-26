
class AdminConstraint
  def matches?(request)
    remember_token = User.digest(request.cookies["remember_token"])
    login_token = LoginToken.find_by(digest_token: remember_token)
    login_token.user if login_token && login_token.user.admin?
  end
end
