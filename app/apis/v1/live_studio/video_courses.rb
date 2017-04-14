module V1
  # 视频课接口
  module LiveStudio
    class VideoCourses < V1::Base
      namespace "live_studio" do
        resource :video_courses do
          desc '搜索视频课'
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
            optional :q, type: Hash, default: {} do
              optional :grade_eq, type: String, desc: '年级', values: APP_CONSTANT['grades_in_menu']
              optional :subject_eq, type: String, desc: '科目', values: APP_CONSTANT['subjects']
              optional :sell_type_eq, type: String, desc: '销售类型 charge: 收费; free: 免费', values: %w[charge free]
            end
            optional :sort_by, type: String, desc: '排序方式', values: %w(price price.asc published_at published_at.asc buy_tickets_count buy_tickets_count.asc)
          end
          get 'search' do
            search_params = ActionController::Parameters.new(params).permit(:sort_by, q: [:status_eq, :grade_eq, :subject_eq, :sell_type_eq])
            sell_type_value = ::LiveStudio::VideoCourse.sell_type.find_value(search_params[:q][:sell_type_eq]).try(:value)
            search_params[:q][:sell_type_eq] = sell_type_value if sell_type_value
            search_params[:q][:s] =
                if search_params[:sort_by].present?
                  by, direction = search_params[:sort_by].split('.')
                  "#{by} #{direction || 'desc'}"
                else
                  'published_at desc'
                end
            q = LiveService::VideoCourseDirector.search(search_params)
            video_courses = q.result.paginate(page: params[:page], per_page: params[:per_page])
            present video_courses, with: Entities::LiveStudio::SearchVideoCourse, type: :full
          end

          desc '视频课详情' do
            headers 'Remember-Token' => {
                        description: 'RememberToken',
                        required: false
                    }
          end
          params do
            requires :id, type: Integer, desc: 'ID'
          end
          get ':id' do
            video_course = ::LiveStudio::VideoCourse.find(params[:id])
            case current_user
              when Student
                present video_course, with: Entities::LiveStudio::StudentVideoCourse, type: :full, current_user: current_user
              when Teacher
                present video_course, with: Entities::LiveStudio::TeacherVideoCourse, type: :full, current_user: current_user
              else
                present video_course, with: Entities::LiveStudio::VideoCourse, type: :full
            end
          end
        end

      end
    end
  end
end
