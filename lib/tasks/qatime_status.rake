task :qatime_status => :environment do

  Solution.all.each do |c|
    c.last_operator_id = c.student_id
    c.save
  end

end