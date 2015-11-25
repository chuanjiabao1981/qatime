task :qatime_status => :environment do

  Solution.all.each do |c|
    c.last_operator_id = c.student_id
    c.save
  end
  kk = []
  ActionRecord.all.each do |a|
    a = [a.id,a.actionable_id]
    kk.append(a)
  end
  kk.each do |k|
    puts k.size
  end
  puts "=========================="
  kk.each do |k|
    
  end
  Notification.all.each do |n|
    puts "#{n.notificationable_id},#{n.notificationable_type}"
  end
end