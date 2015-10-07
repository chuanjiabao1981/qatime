task :add_corrections_count_to_homework2 => :environment do
  Correction.all.each do |c|
    if  c.homework_id == nil
      c.homework_id = c.solution.solutionable_id
      c.save
      puts "#{c.homework.corrections_count}----#{c.reload.homework.corrections_count}"
    end
  end
end