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

# admin initialize
Admin.create(name: 'admin',
            email: 'admin@admin.com',
            password: '123456',
            password_confirmation: '123456',
            role: 'admin') unless Admin.exists?

m = Manager.create(name: 'manager',
            email: 'm1@manager.com',
            password: '123456',
            password_confirmation: '123456',
            role: 'manager') unless Manager.exists?

Workstation.create(name: "第一工作站",
            city_id: 1,
            address: '南三环中路',
            tel: '15811010176',
            email: 'xinshuaifeng@126.com',
            manager_id: m.id
  ) unless Workstation.exists?

Teacher.create(name: 'teacher',
            email: 't1@teacher.com',
            password: '123456',
            password_confirmation: '123456',
            role: 'teacher') unless Teacher.exists?

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
)  if CashAdmin.current.blank?
