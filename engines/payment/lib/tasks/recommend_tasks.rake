# desc "Explaining what the task does"
# task :payment do
#   # Task goes here
# end

namespace :recommend do
  desc "初始化推荐位"
  task positions_seed: :environment do
    unless Recommend::Position.count > 0
      Recommend::Position.create(name: '首页名师推荐', klass_name: 'Recommend::TeacherItem', kee: 'index_teacher_recommend', status: 1)
      Recommend::Position.create(name: '首页辅导班推荐', klass_name: 'Recommend::LiveStudioCourseItem', kee: 'index_live_studio_course_recommend', status: 1)
    end
  end
end
