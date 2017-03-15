module Tally
  extend ActiveSupport::Concern
  included do

    has_one  :fee, as: :feeable
    scope :valid_tally_unit, -> { joins(:customized_course).where(customized_courses:{is_keep_account: true}).
                                    where("customized_course_id is not null").where(:status => "open") }

    before_validation :set_customized_course_prices, on: :create

    validates_presence_of :platform_price, :teacher_price

    def set_customized_course_prices
      customized_course = CustomizedCourse.find(self.customized_course_id)

      if customized_course
        self.platform_price = customized_course.platform_price
        self.teacher_price = customized_course.teacher_price
      end
    end

    def float_format(value)
      format_value = format("%.2f",value).to_f
      format_value
    end


    ##计算
    def __create_fee(video)
      sale_price = self.platform_price + self.teacher_price

      hours                 = Float(video.duration) / 60 / 60
      fee_value             = float_format(hours * sale_price)
      return unless fee_value > 0
      fee = self.build_fee
      fee.value = fee_value
      fee.customized_course_id        = self.customized_course_id
      fee.teacher_price               = self.teacher_price
      fee.platform_price              = self.platform_price
      fee.sale_price                  = self.platform_price + self.teacher_price
      fee.video_duration              = video.duration
      fee.save!
      fee
    end

    # 结账
    def _billing(teacher_id)
      Payment::Billing.create(target: self, total_money: total_money, from_user_id: teacher_id, summary: "#{model_name.human} - #{id} 结算")
    end

    # 扣款
    def __charge_fee(fee)
      customized_course           = CustomizedCourse.find(self.customized_course_id)
      consumption_account         = Student.find(customized_course.student_id).account

      consumption_account.lock!
      consumption_account.money   = consumption_account.money - fee.value
      consumption_account.total_expenditure = consumption_account.total_expenditure + fee.value
      consumption_account.consumption_records.create!(fee: fee,value: fee.value)
      consumption_account.save!
    end

    # 新的扣款
    def __charge_billing(billing)
      student_account = CustomizedCourse.find(customized_course_id).student.cash_account!
      AccountService::CashManager.new(student_account).decrease('Payment::ConsumptionRecord', billing.total_money, billing)
    end

    # 新的分账
    def __split_billing(billing, teacher, workstation)
      AccountService::CashManager.new(teacher.cash_account!).increase('Payment::EarningRecord', teacher_amount, billing)
      AccountService::CashManager.new(workstation.cash_account).increase('Payment::EarningRecord', workstation_amount, billing)
      AccountService::CashManager.new(workstation.available_account).increase('Payment::EarningRecord', workstation_amount, billing)
    end

    def __split_fee_to_relative_account(relative_account, fee, value, price)
      relative_account.lock!
      relative_account.money = relative_account.money + value
      relative_account.total_income = relative_account.total_income + value
      relative_account.earning_records.create!(fee: fee, price: price, value: value)
      relative_account.save!
    end

    # 计算分配比例
    def __calculate_split_value(fee, teacher_account, workstation_account)
      teacher_percent = fee.teacher_price / (fee.teacher_price + fee.platform_price)
      workstation_percent = 1 - teacher_percent
      teacher_value = float_format(fee.value * teacher_percent)
      workstation_value = float_format(fee.value * workstation_percent)
      [[teacher_account, teacher_value, fee.teacher_price], [workstation_account, workstation_value, fee.platform_price]]
    end

    # 分账
    def __split_fee(teacher_id, fee)
      teacher_account = Teacher.find(teacher_id).account
      customized_course = CustomizedCourse.find(customized_course_id)
      workstation_account = Workstation.find(customized_course.workstation_id).account
      __calculate_split_value(fee, teacher_account, workstation_account).each do |account, value, price|
        __split_fee_to_relative_account(account, fee, value, price)
      end
    end

    def keep_account(teacher_id, &block)
      return if video.nil?
      video.sync_duration! if video.duration.blank? || video.duration == 0
      return if video.duration.to_i <= 0
      self.class.transaction do
        lock!
        return if is_charged?
        video.lock!
        begin
          fee = __create_fee(video)
          billing = _billing(teacher_id)
          return if billing.nil? || billing.total_money <= 0
          __charge_fee(fee)
          __split_fee(teacher_id, fee)
          __charge_billing(billing)

          teacher = Teacher.find(teacher_id)
          workstation = Workstation.find(customized_course.workstation_id)

          __split_billing(billing, teacher, workstation)

          self.status = "closed"
          save!
          # 这里是为了注入异常，测试回滚用，对整个流程没有什么帮助
          yield if block_given?
        rescue StandardError => e
          Rails.logger.error("#{e.to_s} \n #{self.model_name.to_s} \n #{self.to_json}")
          raise ActiveRecord::StatementInvalid, "#{e.to_s} \n #{self.model_name.to_s} \n #{self.to_json}"
        end
      end
    end

    def is_charged?
      'closed' == status
    end

    def set_charged
      self.status = "closed"
    end

    def total_price
      teacher_price + platform_price
    end

    protected

    def teacher_amount
      @teacher_amount ||= float_format(teacher_price * hours)
    end

    def workstation_amount
      @workstation_amount ||= float_format(platform_price * hours)
    end

    def hours
      @hours ||= Float(video.duration) / 60 / 60
    end

    def total_money
      float_format(teacher_amount + workstation_amount)
    end
  end
end
