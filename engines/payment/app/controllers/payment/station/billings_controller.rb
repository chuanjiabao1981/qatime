require_dependency "payment/application_controller"

module Payment
  class Station::BillingsController < Station::BaseController
    before_action :set_billing

    def show
      @billing = @workstation
    end

    private

    def set_billing
      @billing ||= Payment::Billing.find(params[:id])
    end

    def current_resource
      @billing.owner
    end
  end
end
