module V2
  # 班级接口
  module LiveStudio
    class Courses < V1::Base
      namespace "live_studio" do
        resource :courses do
          desc '免费课程'
          params do
            optional :count, type: Integer, desc: '记录数量'
          end
          get 'free' do
            live_data = DataService::LiveData.new
            courses = live_data.free_courses(limit: params[:count].presence)
            present courses, with: Entities::Common::Course
          end

          desc '最新课程'
          params do
            optional :count, type: Integer, desc: '记录数量'
          end
          get 'latest' do
            live_data = DataService::LiveData.new
            courses = live_data.latest_courses(limit: params[:count])
            present courses, with: Entities::Common::Course
          end
        end
      end
    end
  end
end
