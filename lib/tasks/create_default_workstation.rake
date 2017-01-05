task :create_default_workstation => :environment do
  manager = Manager.where(email:"machengke@qatime.cn").first
  city = City.first

  workstation = Workstation.new

  workstation.name = "阳泉工作站"
  workstation.address = "山西阳泉开发区远东大厦809"
  workstation.tel = "400-838-8010"
  workstation.email = "yangquan@qatime.cn"

  workstation.manager = manager
  workstation.city = city

  workstation.build_account
  workstation.save!
end