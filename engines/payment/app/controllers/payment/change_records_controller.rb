require_dependency "payment/application_controller"

module Payment
  class ChangeRecordsController < ApplicationController
    before_action :set_change_record, only: [:show, :edit, :update, :destroy]

    # GET /change_records
    def index
      @change_records = @current_resource.cash_account!.change_records.includes(billing: :target).paginate(page: params[:page])
    end

    # GET /change_records/1
    def show
    end

    private
    def current_resource
      @current_resource ||= User.find(params[:user_id])
    end

  end
end
