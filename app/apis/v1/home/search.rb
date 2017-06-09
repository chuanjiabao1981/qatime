module V1
  # 优惠码接口
  module Home
    class Search < V1::Base
      namespace "home" do
        resource :search do

          desc '首页课程,教师搜索'
          params do
            requires :search_cate, type: String, desc: '课程: course; 教师: teacher', values: %w[course teacher]
            optional :search_key, type: String, desc: '关键字'
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
          end
          get do
            search_data = DataService::SearchManager.new(params[:search_cate])
            if params[:search_cate] == 'teacher'
              teachers = search_data.search(params[:search_key]).paginate(page: params[:page], per_page: params[:per_page])
              present teachers, with: Entities::SearchTeacher, total_entries: teachers.total_entries
            else
              courses = search_data.search(params[:search_key]).paginate(page: params[:page], per_page: params[:per_page])
              present courses, with: Entities::LiveStudio::HomeSearchCourse, total_entries: courses.total_entries
            end
          end
        end
      end
    end
  end
end
