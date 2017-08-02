module BusinessService
  # 一对一直播课结账
  class CustomizedGroupBillingDirector
    def initialize(target)
      @target = target
    end

    # 专属课结算
    def billing
      @target.events.billingable.map {|event| billing_lesson(event) }
    end

    # 专属课时结算
    def billing_lesson(lesson)
      BusinessService::Billing::EventLesson.new(lesson).execute!
    end
  end
end
