task :vip_class_init => :environment do
  APP_CONSTANT["categories"].each do |category|
    APP_CONSTANT["subjects"].each do |subject|
      if APP_CONSTANT["vip_class_ids"][category]
        if APP_CONSTANT["vip_class_ids"][category][subject]
          begin
            VipClass.find(APP_CONSTANT["vip_class_ids"][category][subject])
            puts "find #{category}#{subject} #{APP_CONSTANT["vip_class_ids"][category][subject]}"
          rescue ActiveRecord::RecordNotFound
            a=VipClass.new
            a.id = APP_CONSTANT["vip_class_ids"][category][subject]
            a.category = category
            a.subject = subject
            a.save
            puts "create #{category}#{subject} #{APP_CONSTANT["vip_class_ids"][category][subject]}"
          end
        end
      end
    end
  end
end