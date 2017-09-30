require_dependency "payment/application_controller"

module Payment
  class Admin::BaseController < ApplicationController
    layout 'admin_home'
  end
end
