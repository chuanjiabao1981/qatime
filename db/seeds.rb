# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# city initialize
%w(北京 上海 广州 深圳).each do |city_name|
  City.create(name: city_name)
end unless City.count > 0

# school initialize
%w(一中 二中 三中).each do |suffix|
  City.find_each do |city|
    city.schools.create(name: "#{city.name}#{suffix}")
  end
end unless School.exists?


# initialize register codes
School.find_each do |school|
  RegisterCode.batch_make(10.to_s, school) # ...... 不要问我为啥10.to_s 我想静静
end unless RegisterCode.exists?

# admin initialize
Admin.create(
    name: 'admin',
    email: 'admin@admin.com',
    password: '123456',
    password_confirmation: '123456',
    role: 'admin'
) unless Admin.exists?

m = Manager.create(
    name: 'manager',
    email: 'm1@manager.com',
    password: '123456',
    password_confirmation: '123456',
    role: 'manager'
) unless Manager.exists?

Workstation.create(
    name: "第一工作站",
    city_id: 1,
    address: '南三环中路',
    tel: '15811010176',
    email: 'xinshuaifeng@126.com',
    manager_id: m.id
) unless Workstation.exists?
unless Teacher.exists?
  Teacher.new(
      name: 'teacher',
      email: 't1@teacher.com',
      password: '123456',
      password_confirmation: '123456',
      role: 'teacher',
      type: 'Teacher',
      mobile: '13111111111',
      avatar: 'no_avatar',
      school_id: School.first.id,
      register_code_value: RegisterCode.able_code.first.value,
      subject: '自然',
      category: '初中'
  ).save(validate: false)
end
unless Student.exists?
  Student.new(
      name: 'student',
      email: 's1@student.com',
      password: '123456',
      password_confirmation: '123456',
      role: 'student',
      type: 'Student'
  ).save(validate: false)
end

unless LiveStudio::Course.exists?
  @course =
      LiveStudio::Course.create(
          name: '第一辅导班',
          teacher_id: Teacher.first.id,
          workstation_id: Workstation.first.id,
          status: 1,
          description: 'this is description',
          price: 200,
          teacher_percentage: 70,
          author_id: User.first.id,
          subject: '自然',
          grade: '初三',
          preset_lesson_count: 2
      )
 # LiveService::ChatAccountFromUser.new(@course.teacher).instance_account
end

# vip class initialize
APP_CONSTANT["vip_class_ids"].each do |cate, value|
  value.each do |subject, class_id|
    VipClass.create(id: class_id, subject: subject, category: cate)
  end
end unless VipClass.exists?

# cash_admin init
CashAdmin.create(
    name: 'cash_admin',
    email: 'cash_admin@admin.com',
    password: '123456',
    password_confirmation: '123456',
    role: 'cash_admin'
)  if CashAdmin.current!.blank?
