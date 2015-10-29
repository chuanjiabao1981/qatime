task :create_default_workstation => :environment do
  manager = Manager.where(email:"machengke@qatime.cn").first
  city = City.first

  workstation = Workstation.new

  workstation.name = "阳泉工作站"
  workstation.address = "阳泉"
  workstation.tel = "13439338326"
  workstation.email = "yangquan@qatime.cn"

  workstation.manager = manager
  workstation.city = city

  workstation.build_account
  workstation.save!
end