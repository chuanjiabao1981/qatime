require 'test_helper'

module LiveServiceTest
  class TaskBillingDirectorTest < ActiveSupport::TestCase
    # 销售任务完成考核
    test 'test billing a finished task' do
      @workstation = workstations(:workstation_one)
      @sale_task = payment_sale_tasks(:task_three)
      BusinessService::TaskBillingDirector.new(@sale_task).task_billing
    end

    # 销售任务未完成考核
    test 'test billing a unfinished task' do
      @workstation = workstations(:workstation_hd)
      @sale_task = payment_sale_tasks(:task_four)
      BusinessService::TaskBillingDirector.new(@sale_task).task_billing
    end
  end
end
