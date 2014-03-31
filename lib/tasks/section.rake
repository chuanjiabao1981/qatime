sections=[
    ["高中科目",["高中物理","高中数学","高中化学","高中生物","高中奥数"]],
    ["初中科目",["初中物理","初中数学","初中化学","初中生物","初中奥数"]],
    ["学习方法",["高中","初中"]],
    ["问答",["投诉与建议"]]
]
task :section_init => :environment do
  sections.each do | section|
    sec = Section.find_or_create_by!(name:section[0])
    section[1].each do |node|
      Node.find_or_create_by!(name:node,section:sec,summary:node)
    end
  end
end
