module V1
  # 首页查询功能接口
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
              teachers = search_data.search_old(params[:search_key]).paginate(page: params[:page], per_page: params[:per_page])
              present teachers, with: Entities::SearchTeacher, total_entries: teachers.total_entries
            else
              courses = search_data.search_old(params[:search_key]).paginate(page: params[:page], per_page: params[:per_page])
              present courses, with: Entities::LiveStudio::HomeSearchCourse, total_entries: courses.total_entries
            end
          end
        end

        resource :teachers do
          desc '首页全部教师搜索'
          params do
            optional :category_eq, type: String, desc: '类型', values: APP_CONSTANT['categories']
            optional :subject_eq, type: String, desc: '科目', values: APP_CONSTANT['subjects']
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
          end
          get do
            teachers = DataService::SearchManager.teachers_ransack(params).result.paginate(page: params[:page], per_page: params[:per_page])
            present teachers, with: Entities::SearchTeacher, total_entries: teachers.total_entries
          end
        end

        resource :replays do
          desc '首页全部精彩回放'
          params do
            optional :s, type: String, desc: '默认updated_at desc排序(中间空格),需要正序加上 asc后缀 例如: updated_at desc updated_at asc replay_times desc replay_times desc', values: [ 'updated_at desc', 'updated_at asc', 'replay_times desc', 'replay_times asc' ]
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
          end
          get do
            params[:s] ||= 'updated_at desc'
            items = ::Recommend::ReplayItem.default.items.where.not(target_type: 'LiveStudio::ScheduledLesson').ransack(params).result.paginate(page: params[:page], per_page: params[:per_page])

            present items, with: Entities::Recommend::ReplayItemSearch
          end

          desc '精彩回放播放页'
          params do
            requires :id, type: Integer, desc: 'id.'
          end
          route_param :id do
            get :replay do
              item = ::Recommend::ReplayItem.default.items.find(params[:id])
              item.increment_replay_times if item
              present item, with: Entities::Recommend::ReplayItemDetail
            end
          end
        end

        desc '近期直播'
        params do
          optional :page, type: Integer, desc: '当前页面'
          optional :per_page, type: Integer, desc: '每页记录数'
        end
        get 'recent_lessons' do
          home_data = DataService::HomeData.new
          recent_lessons = home_data.recent_lessons(params[:per_page])
          present recent_lessons, with: ::Entities::LiveStudio::LessonSchedule
        end
      end
    end
  end
end
