task :customized_course_add_price_and_creator => :environment do

  manager = Manager.where(email:"machengke@qatime.cn").first
  workstation = Workstation.by_manager_id(manager.id).first

  # 修改专属课堂的价格，16之前的id统统用老价格，后面用新价格
  CustomizedCourse.all.each do |customized_course|
    if customized_course and customized_course.creator_id.nil?
      customized_course.creator_id = manager.id
      customized_course.workstation_id = workstation.id
    end

    if customized_course and customized_course.teacher_price.nil?
      teacher_price, platform_price = CustomizedCourse.get_customized_course_prices(customized_course.category, "heighten")
      if customized_course.id < 16 and customized_course.id != 15
        customized_course.platform_price = 0
      else
        customized_course.platform_price = platform_price
      end
      customized_course.teacher_price = teacher_price
      customized_course.heighten!
    end
  end


  # 专属课堂相关的计费单元，把价格带上
  [CustomizedTutorial, Correction, CourseIssueReply, TutorialIssueReply].each do |s|
    s.all.each do |object|
      if object
        if object.platform_price.nil? or object.teacher_price.nil?
          object.set_customized_course_prices
          object.save!
        end
      end
    end
  end

  # 将fee的价格设置上
  Fee.all.each do |fee|
    fee.teacher_price = fee.feeable.teacher_price
    fee.platform_price = fee.feeable.platform_price
    sale_price = fee.feeable.teacher_price + fee.feeable.platform_price
    fee.sale_price = sale_price
    fee.save!
  end


  #
  EarningRecord.all.each do |er|
    if er.account.accountable_type == "User"
      er.price = er.fee.teacher_price
    elsif er.account.accountable_type == "Workstation"
      er.price = er.fee.platform_price
    end
    er.save!

    account = er.account
    account.transaction do
      account.lock!
      total_income = account.total_income
      account.total_income = total_income + er.value
      account.save!
    end
  end

  ConsumptionRecord.all.each do |cr|
    account = cr.account

    account.transaction do
      account.lock!
      account.total_expenditure = account.total_expenditure + cr.value
      account.save!
    end
  end


end