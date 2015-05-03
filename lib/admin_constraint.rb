
class AdminConstraint

  def matches?(request)
    remember_token = User.digest(request.cookies["remember_token"])
    u = Admin.find_by remember_token: remember_token
    u
  end
end