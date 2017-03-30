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
            optional :q, type: Hash, default: {} do
              optional :grade_eq, type: String, desc: '年级', values: APP_CONSTANT['grades_in_menu']
              optional :subject_eq, type: String, desc: '科目', values: APP_CONSTANT['subjects']
            end
            optional :sort_by, type: String, desc: '排序方式', values: %w(price price.asc published_at published_at.asc buy_tickets_count buy_tickets_count.asc)
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
            interactive_courses = q.result.paginate(page: params[:page], per_page: params[:per_page])
            present interactive_courses, with: Entities::LiveStudio::SearchInteractiveCourse
          end

          desc '一对一直播详情' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            requires :id, type: Integer, desc: '直播ID'
          end
          get ':id' do
            interactive_course = ::LiveStudio::InteractiveCourse.find(params[:id])
            case current_user
            when Student
              present interactive_course, with: Entities::LiveStudio::StudentInteractiveCourse, type: :full, current_user: current_user
            when Teacher
              present interactive_course, with: Entities::LiveStudio::TeacherInteractiveCourse, type: :full, current_user: current_user
            else
              present interactive_course, with: Entities::LiveStudio::InteractiveCourse, type: :full
            end
          end
        end

        namespace :interactive_courses do
          route_param :interactive_course_id do
            desc '直播状态' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
            end
            get 'live_status' do
              LiveService::InteractiveRealtimeService.new(params[:interactive_course_id]).live_detail(current_user.try(:id))
            end
          end
        end
      end
    end
  end
end
