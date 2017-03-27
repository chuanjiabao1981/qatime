module V1
  # 一对一直播接口
  module LiveStudio
    class InteractiveCourses < V1::Base
      namespace "live_studio" do
        resource :interactive_courses do
          desc '搜索一对一直播'
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
            optional :tags, type: String, desc: '标签'
            optional :range, type: String, values: %w(1_months 2_months 3_months 6_months 1_year), desc: '查询区间'
            optional :q, type: Hash, default: {} do
              optional :grade_eq, type: String, desc: '年级', values: APP_CONSTANT['grades_in_menu']
              optional :subject_eq, type: String, desc: '科目', values: APP_CONSTANT['subjects']
              optional :class_date_gteq, type: String, desc: '开课日期开始时间'
              optional :class_date_lt, type: String, desc: '开课日期结束时间'
            end
            optional :sort_by, type: String, desc: '排序方式', values: %w(left_price left_price.asc published_at published_at.asc buy_tickets_count buy_tickets_count.asc)
          end
          get 'search' do
            search_params = ActionController::Parameters.new(params).permit(:tags, :range, :sort_by, q: [:status_eq, :grade_eq, :subject_eq, :class_date_gteq, :class_date_lt])
            search_params[:q][:status_eq] = ::LiveStudio::InteractiveCourse.statuses[search_params[:q][:status_eq]] if search_params[:q][:status_eq].present?
            search_params[:q][:s] =
              if search_params[:sort_by].present?
                by, direction = search_params[:sort_by].split('.')
                "#{by} #{direction || 'desc'}"
              else
                'published_at desc'
              end
            q = LiveService::InteractiveCourseDirector.search(search_params)
            courses = q.result.paginate(page: params[:page], per_page: params[:per_page])
            present courses, with: Entities::LiveStudio::SearchInteractiveCourse, type: :default
          end
        end
      end
    end
  end
end
