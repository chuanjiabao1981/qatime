class GroupCell < Cell::Rails
  def nav
    @cities = City.all
    render
  end
end
