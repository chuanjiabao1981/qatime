class NodeCell < Cell::Rails
  def course_card(args)
    @node = Node.where(name: args[:name]).order(created_at: :desc).take
    render
  end
end
