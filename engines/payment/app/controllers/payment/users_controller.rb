require_dependency "payment/application_controller"

module Payment
  class UsersController < ApplicationController
    def cash
      @change_records = @current_resource.cash_account!.change_records.includes(billing: :target).paginate(page: params[:page])
    end

    private

    def current_resource
      @current_resource ||= User.find(params[:id])
    end
  end
end
