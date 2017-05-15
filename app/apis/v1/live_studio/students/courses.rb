module V1
  module LiveStudio
    module Students
      class Courses < V1::Base
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

              resource :courses do
                desc '我的试听直播课' do
                  headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
                end
                params do
                  requires :student_id, type: Integer
                  optional :page, type: Integer
                  optional :per_page, type: Integer
                end
                get 'tasting' do
                  video_courses = @student.live_studio_taste_courses.paginate(page: params[:page], per_page: params[:per_page])
                  present video_courses, with: Entities::LiveStudio::StudentCourse
                end

                desc '学生我的直播课' do
                  headers 'Remember-Token' => {
                      description: 'RememberToken',
                      required: true
                  }
                end
                params do
                  optional :page, type: Integer, desc: '当前页面'
                  optional :per_page, type: Integer, desc: '每页记录数'
                  optional :cate, type: String, desc: '分类 today: 今日; taste: 试听', values: %w(today taste)
                  optional :status, type: String, desc: '辅导班状态 published: 待开课; teaching: 已开课; completed: 已结束', values: %w(published teaching completed)
                end
                get '' do
                  courses =
                    if params[:cate].present?
                      LiveService::StudentLiveDirector.new(current_user).courses_of_cate(params[:cate])
                    else
                      LiveService::StudentLiveDirector.new(current_user).courses(params)
                    end
                  courses = courses.paginate(page: params[:page], per_page: params[:per_page])
                  present courses, with: Entities::LiveStudio::StudentCourse, type: :default, current_user: current_user
                end

                desc '学生辅导班详情接口' do
                  headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
                end
                params do
                  requires :id, type: Integer, desc: '辅导班ID'
                end
                get ':id' do
                  course = current_user.live_studio_courses.find(params[:id])
                  present course, with: Entities::LiveStudio::StudentCourse, type: :full, current_user: current_user, size: :info
                end
              end

              desc '学生课程表接口' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                optional :month, type: String, desc: '月份: 2016-10-01 该值为空则默认返回当月数据'
                optional :state, type: String, desc: '课程状态:未上课 已完成 不传则默认返回全部', values: %w(unclosed closed)
              end
              get 'schedule' do
                arr = LiveService::CourseDirector.courses_by_month(current_user, params[:month], params[:state])
                present arr, with: Entities::LiveStudio::Schedule, type: :schedule
              end
            end
          end
        end
      end
    end
  end
end
