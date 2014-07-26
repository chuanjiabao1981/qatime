task :group_type_init => :environment do
  APP_GROUP.each do |group_type|
    g_type = GroupType.find_or_create_by!({name: group_type["name"],grade: group_type["grade"],subject: group_type["subject"]})

    group_type["catalogues"].each_with_index do |name,index|
      cat = GroupCatalogue.find_or_create_by!({name: name.to_s,group_type_id:g_type.id})
      cat.index = index * 100
      cat.save
    end
  end
end