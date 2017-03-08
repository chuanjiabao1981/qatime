module Payment
  # 资金变动
  module CashChangeable
    extend ActiveSupport::Concern
    # 生成账户明细类型
    def change_record_type(_direction)
      "Payment::ChangeRecord"
    end

    # 是否外部资金变动
    def external?(_direction)
      false
    end
  end
end
