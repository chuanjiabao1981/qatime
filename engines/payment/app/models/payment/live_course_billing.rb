module Payment
  class LiveCourseBilling < Billing
    # 计算总金额
    def calculate
      self.total_money = target.billing_amount
    end

    def billing
      target.ticket_items.billingable.includes(ticket: [:channel_owner, :sell_channel]).each do |item|
        item.with_lock do
          LiveCourseTicketBilling.create(target: target, from_user: from_user, parent: self, ticket: item.ticket).billing
          item.settled!
        end
      end
      target.complete! if target.ticket_items.billingable.blank?
    end
  end
end
