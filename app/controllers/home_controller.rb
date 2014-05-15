class HomeController < ApplicationController
  layout 'application_home'
  def index
    @nodes = Node.all
  end
end
