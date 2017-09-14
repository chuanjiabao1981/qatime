module V2
  # 班级接口
  module LiveStudio
    class Lessons < V1::Base
      namespace "live_studio" do
        resource :lessons do
          desc '今日课程'
          get 'today' do
            live_data = DataService::LiveData.new
            lessons = live_data.today_lessons
            present lessons, with: Entities::Common::Lesson
          end
        end
      end
    end
  end
end
