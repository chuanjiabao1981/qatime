module LiveStudio
  class VideoCourseBillingJob < ActiveJob::Base
    queue_as :live_studio

    def perform(ticket_id)
      ticket = LiveStudio::BuyTicket.find(ticket_id)
      BusinessService::VideoCourseBillingDirector.new(ticket).billing_ticket
    end
  end
end
