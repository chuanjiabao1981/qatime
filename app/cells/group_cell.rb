class GroupCell < Cell::Rails
  def nav
    @cities = City.all
    @all_group_types = GroupType.all
    render
  end
end
