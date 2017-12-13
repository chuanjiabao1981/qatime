module Exam
  # 关联关系
  module Association
    extend ActiveSupport::Autoload
    autoload :Workstation
    autoload :Student
    autoload :Teacher
  end
end
