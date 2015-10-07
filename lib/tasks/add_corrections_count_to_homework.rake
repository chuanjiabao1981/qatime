task :add_corrections_count_to_homework => :environment do
  Correction.all.each do |c|
    puts c.id
    puts c.solution.solutionable_type
    puts c.solution.solutionable_id
    if c.solution.solutionable_type != Homework.to_s

      puts "fail !!!!!!"
      next
    end
    puts "success ................."
    c.homework_id = c.solution.solutionable_id
    c.save
    puts c.reload.homework.corrections_count
  end
end