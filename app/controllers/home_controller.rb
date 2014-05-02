class HomeController < ApplicationController

  skip_before_filter :authenticate_user!
  def index
    @nodes = Node.all
  end
end
