class AddQqToWorkstations < ActiveRecord::Migration
  def change
    add_column :workstations, :status, :integer, default: 1 # qq
    add_column :workstations, :qq, :string # qq
    add_column :workstations, :join_price, :decimal, precision: 10, scale: 2, default: 0 # 加盟费
    add_column :workstations, :caution_money, :decimal, precision: 10, scale: 2, default: 0 # 保证金
    add_column :workstations, :platform_percentage, :integer, default: 0 # 平台分成
    add_column :workstations, :service_price, :decimal, precision: 4, scale: 2, default: 0 # 服务扣费
    add_column :workstations, :contract_start_date_at, :datetime # 合同有效期
    add_column :workstations, :contract_end_date_at, :datetime # 合同有效期
  end
end
