module Payment
  module Billings
    # 课时购买项账单
    class TicketItemBilling < Billing
      belongs_to :ticket, polymorphic: true

      def lesson_price
        ticket.lesson_price
      end

      # 计算总金额
      def calculate
        self.total_money = ticket.lesson_price
      end

      # 系统服务费
      def base_fee
        @base_fee ||= [base_price * target.duration_hours, total_money].min.round(2)
      end

      def base_price
        @base_price ||= target.base_price
      end

      # 分成金额
      def percent_money
        @percent_money = total_money - base_fee
      end

      # 教师收入
      def teacher_money
        @teacher_money ||= (percent_money * teacher_proportion).round(2)
      end

      def teacher_percentage
        @teacher_percentage ||= target.teacher_percentage
      end

      # 经销商分成收入
      def sell_money
        @sell_money ||= (percent_money * sell_proportion).round(2)
      end

      # 销售经销商分成百分比
      def sell_percentage
        ticket.sell_percentage
      end

      # 平台分成收入
      def platform_money
        @platform_money ||= percent_money - teacher_money - publish_money - sell_money
      end

      # 跨区销售分成百分比
      # 不能大于销售分成比例
      def platform_percentage
        ticket.platform_percentage
      end

      # 发行商分成收入
      def publish_money
        @publish_money ||= (percent_money * publish_proportion).round(2)
      end

      def publish_percentage
        @publish_percentage ||= target.publish_percentage
      end

      # 平台服务费项
      def system_fee_item
        billing_items.find {|item| item.type == 'Payment::SystemFeeItem' }
      end

      # 销售分成项
      def sell_percent_item
        billing_items.find {|item| item.type == 'Payment::SellPercentItem' }
      end

      # 平台分成项
      def platform_percent_item
        billing_items.find {|item| item.type == 'Payment::PlatformPercentItem' }
      end

      # 发行分成项
      def publish_percent_item
        billing_items.find {|item| item.type == 'Payment::PublishPercentItem' }
      end

      # 教师收入项
      def teacher_money_item
        billing_items.find {|item| item.type == 'Payment::TeacherMoneyItem' }
      end

      private

      # 教师分成比例
      def teacher_proportion
        target.teacher_percentage.to_f / 100
      end

      # 经销商分成比例
      def sell_proportion
        sell_percentage.to_f / 100
      end

      # 跨区销售系统分成比例
      def platform_proportion
        platform_percentage.to_f / 100
      end

      # 发行商分成比例
      def publish_proportion
        target.publish_percentage.to_f / 100
      end

      # 总分成比例
      def total_proportion
        (teacher_proportion + sell_proportion + platform_proportion + publish_proportion).round(2)
      end

      # 根据百分比计算得出平台
      def real_platform_money
        (percent_money * platform_proportion).round(2)
      end

      before_save :billing_check!
      def billing_check!
        calculate
        raise Payment::TotalPercentInvalid, "分成比例不正确" unless  1 == total_proportion
        raise Payment::SystemMoneyDifference, "平台分成金额差距过大" if (real_platform_money - platform_money).abs > 0.02
      end
    end
  end
end
