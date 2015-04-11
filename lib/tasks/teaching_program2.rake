task :teaching_program_init2 => :environment do

  dry_run = false
  TeachingProgramConf=YAML.load(File.read(File.expand_path('../../../config/teaching_program.yml',__FILE__)))
  puts "########### Teaching Program ##################"
  TeachingProgramConf.each do |t|
    a = TeachingProgram.where(name: t["name"],subject: t["subject"],grade: t["grade"])
    if a.size == 0
      a = TeachingProgram.new(t)
      puts a.save
    end
  end

end