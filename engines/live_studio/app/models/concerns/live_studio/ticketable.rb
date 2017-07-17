module LiveStudio
  module Ticketable
    extend ActiveSupport::Concern

    included do
      has_many :tickets, as: :product # 听课证
      has_many :buy_tickets, as: :product # 普通听课证
      has_many :taste_tickets, as: :product # 试听证
    end

    # 发送听课证
    def grant(order)
      clean_taste_ticket!(order.user)
      return false unless check_ticket(order.user)
      buy_tickets.create(buy_params(order))
    end

    # 免费课程
    def free_grant(user)
      return false unless respond_to?(:sell_type)
      return false unless sell_type.free?
      return false unless check_ticket(user)
      buy_tickets.create(free_params(user))
    end

    # 试听
    def taste(user)
      # 试听检查
      return false unless taste_check(user)
      # 购买或者正在试听
      return false unless check_ticket(user)
      taste_tickets.create(taste_params(user))
    end

    def ticket_for(user)
      # 正在使用的听课证
      ticket = tickets.available.find_by(student: user)
      # 试听历史
      ticket ||= taste_tickets.find_by(student: user)
      ticket
    end

    private

    # 清理旧的听课证
    def clean_taste_ticket!(student)
      taste_tickets.where(student_id: student.id).available.map(&:replaced!) # 替换正在使用的试听券
    end

    # 检查重复听课证
    def check_ticket(student)
      tickets.available.find_by(student_id: student.id).nil?
    end

    # 试听检查
    def taste_check(student)
      taste_count < unclosed_lessons_count && !tasted?(student)
    end

    # 购买参数
    def buy_params(order)
      ticket_price = order.amount.to_f / unclosed_lessons_count
      {
        student_id: order.user_id,
        lesson_price: ticket_price,
        payment_order: order,
        buy_count: unclosed_lessons_count,
        item_targets: buy_items,
        status: 'active'
      }
    end

    def free_params(user)
      {
        student_id: user.id,
        lesson_price: 0,
        buy_count: unclosed_lessons_count,
        item_targets: buy_items,
        status: 'active'
      }
    end

    # 试听参数
    def taste_params(user)
      {
        student_id: user.id,
        buy_count: taste_count.to_i,
        item_targets: taste_items,
        status: 'active'
      }
    end

    # 购买项目
    def buy_items
    end

    # 试听项目
    def taste_items
    end
  end
end
