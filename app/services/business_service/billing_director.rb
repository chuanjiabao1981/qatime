module BusinessService
  # 课程结账
  class BillingDirector
    def self.billing_lessons
      # 直播课结账
      LiveService::LessonDirector.billing_lessons
      # 一对一结账
      LiveService::InteractiveLessonDirector.billing_lessons
      # 专属课结账
      LiveService::CustomizedGroupBillingDirector.billing_lessons
    end
  end
end
