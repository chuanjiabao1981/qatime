module Payment
  class ApplicationController < ::ApplicationController
    layout 'payment/layouts/application'
    before_action :current_resource

    private
    def current_resource
      @current_resource ||= ::User.find(params[:user_id]) if params[:user_id]
    end
  end
end
