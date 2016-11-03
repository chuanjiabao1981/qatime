# desc "Explaining what the task does"
# task :payment do
#   # Task goes here
# end

namespace :recommend do
  desc "初始化推荐位"
  task positions_seed: :environment do
    unless Recommend::Position.count > 0
      p = Recommend::Position.create(name: '首页名师推荐', klass_name: 'Recommend::TeacherItem', kee: 'index_teacher_recommend', status: 1)
      Teacher.where(id: [531, 2245, 964, 530, 2479, 2266, 129, 167, 238, 2420]).each_with_index do |t, i|
        p.items.create(title: "名师推荐: #{t.name}", target: t, index: i + 1, type: p.klass_name)
      end

      p = Recommend::Position.create(name: '首页辅导班推荐', klass_name: 'Recommend::LiveStudioCourseItem', kee: 'index_live_studio_course_recommend', status: 1)
      LiveStudio::Course.where(id: [61, 53, 56, 52, 55, 58, 60, 59]).each_with_index do |c, i|
        p.items.create(title: "辅导班推荐: #{c.name}", target: c, index: i + 1, type: p.klass_name)
      end
    end
  end
end
