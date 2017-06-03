module V1
  # 辅导班接口
  module LiveStudio
    module Students
      class InteractiveCourses < V1::Base
        namespace "live_studio" do
          namespace :students do
            before do
              authenticate!
            end
            route_param :student_id do
              helpers do
                def auth_params
                  @student ||= ::Student.find_by(id: params[:student_id])
                end
              end

              desc '新我的一对一列表' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                requires :student_id, type: Integer
                optional :page, type: Integer
                optional :per_page, type: Integer
                requires :status, type: String, desc: '一对一状态 teaching: 学习中; completed: 已结束', values: %w(teaching completed)
              end
              get 'interactive_courses/list' do
                tickets = @student.live_studio_buy_tickets.available.where(product_type: 'LiveStudio::InteractiveCourse').includes(product: [:interactive_lessons, :teachers])
                tickets = tickets.joins('left outer join live_studio_interactive_courses on live_studio_interactive_courses.id = live_studio_tickets.product_id')
                                 .where("live_studio_interactive_courses.status = ?", ::LiveStudio::InteractiveCourse.statuses[params[:status]])
                tickets = tickets.paginate(page: params[:page], per_page: params[:per_page])
                present tickets, with: Entities::LiveStudio::InteractiveCourseTicket
              end

              desc '我的一对一直播' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                requires :student_id, type: Integer
                optional :page, type: Integer
                optional :per_page, type: Integer
                optional :cate, type: String, desc: '分类 today: 今日; taste: 试听', values: %w(today taste)
                optional :status, type: String, desc: '辅导班状态 published: 待开课; teaching: 已开课; completed: 已结束', values: %w(published teaching completed)
              end
              get 'interactive_courses' do
                interactive_courses = LiveService::StudentLiveDirector.new(@student).interactive_courses(params).paginate(page: params[:page], per_page: params[:per_page])
                present interactive_courses, with: Entities::LiveStudio::StudentInteractiveCourse, type: :default, current_user: current_user
              end
            end
          end
        end
      end
    end
  end
end
