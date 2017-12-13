module Exam
  class Paper < ActiveRecord::Base
    enum status: { unpublished: 0, published: 1 }

    scope :for_sell, -> { where(status: 1) }

    belongs_to :workstation, class_name: '::Workstation'

    has_many :topics
    has_many :categories
    has_many :tickets, as: :product
    has_many :students, through: :tickets

    accepts_nested_attributes_for :categories

    validates :name, presence: true
    validates :grade_category, presence: true
    validates :subject, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }

    # 是否在售
    def for_sell?
      published?
    end

    # 用户数量
    # TODO: 删掉
    def users_count
      0
    end

    # 当前价格
    def current_price
      price
    end

    def grade_category_subject
      "#{grade_category}#{subject}"
    end

    # 发货
    def deliver(order)
      tickets.create(
        student_id: order.user_id,
        price: current_price,
        payment_order: order
      )
    end

    # 已经购买
    def bought_by?(user)
      user.present? && students.include?(user)
    end

    def order_params
      { total_amount: current_price, amount: current_price, product: self }
    end

    def validate_order(order)
      user = order.user
      order.errors[:product] << '商品不存在或者已下架' unless for_sell?
      order.errors[:product] << '只有学生可以购买' unless user.student?
      order.errors[:product] << '您已经购买过该试卷' if bought_by?(user)
    end
  end
end
