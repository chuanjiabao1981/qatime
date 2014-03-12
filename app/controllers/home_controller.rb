class HomeController < ApplicationController
  def index
    @nodes = Node.all
  end
end
