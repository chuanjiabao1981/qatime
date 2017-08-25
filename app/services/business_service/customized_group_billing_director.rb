module BusinessService
  # 一对一直播课结账
  class CustomizedGroupBillingDirector
    def initialize(target)
      @target = target
    end

    # 专属课时结算
    def billing_lesson
      BusinessService::Billing::EventLesson.new(@target).execute!
    end

    # 结算课程
    def self.billing_lessons
      LiveStudio::Event.should_complete.each do |event|
        next unless event.can_billing?
        BusinessService::CustomizedGroupBillingDirector.new(event).billing_lesson
      end
    end

    # 专属课结算
    def self.billing_group(group)
      group.events.billingable.map {|event| BusinessService::CustomizedGroupBillingDirector.new(event).billing_lesson }
    end
  end
end
