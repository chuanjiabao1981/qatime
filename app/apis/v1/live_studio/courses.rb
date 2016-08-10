module V1
  # 辅导班接口
  module LiveStudio
    class Courses < V1::Base
      namespace "live_studio" do
        before do
          authenticate!
        end
        namespace :teachers do

          route_param :teacher_id do
            resource :courses do
              desc '教师辅导班列表接口' do
                headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                }
              end
              params do
                optional :page, type: Integer, desc: '当前页面'
                optional :per_page, type: Integer, desc: '每页记录数'
                optional :status, type: String,desc: '过滤条件 init:初始化; preview: 待开课; teaching: 已开课; completed: 已结束; today: 今日有课的辅导班',
                         values: %w(init preview teaching completed today)
              end
              get do
                courses = LiveService::CourseDirector.courses_for_teacher_index(current_user, params).
                  paginate(page: params[:page], per_page: params[:per_page])
                present courses, with: Entities::LiveStudio::TeacherCourse, type: :default
              end

              desc '教师辅导班全信息接口' do
                headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                }
              end
              params do
                optional :page, type: Integer, desc: '当前页面'
                optional :per_page, type: Integer, desc: '每页记录数'
                optional :status, type: String,desc: '过滤条件 init:初始化; preview: 待开课; teaching: 已开课; completed: 已结束; today: 今日有课的辅导班',
                         values: %w(init preview teaching completed today)
              end
              get :full do
                courses = LiveService::CourseDirector.courses_for_teacher_index(current_user, params).
                  paginate(page: params[:page], per_page: params[:per_page])
                present courses, with: Entities::LiveStudio::TeacherCourse, type: :full
              end

              desc '教师辅导班详情接口' do
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
                present course, with: Entities::LiveStudio::TeacherCourse, type: :full
              end
            end
          end
        end

        namespace :students do
          route_param :student_id do
            resource :courses do
              desc '学生我的辅导班列表接口' do
                headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                }
              end
              params do
                optional :page, type: Integer, desc: '当前页面'
                optional :per_page, type: Integer, desc: '每页记录数'
                optional :cate, type: String, desc: '分类 today: 今日; taste: 试听', values: %w(today taste)
                optional :status, type: String, desc: '辅导班状态 preview: 待开课; teaching: 已开课; completed: 已结束', values: %w(preview teaching completed)
              end
              get do
                tickets = LiveService::CourseDirector.courses_for_student_index(current_user,params).paginate(page: params[:page], per_page: params[:per_page])
                courses = tickets.map(&:course)
                present courses, with: Entities::LiveStudio::StudentCourse, type: :default, options: current_user
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
                present course, with: Entities::LiveStudio::StudentCourse, type: :full, options: current_user
              end
            end
          end
        end

        resource :courses do
          desc '检索辅导班列表接口' do
            headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
            }
          end
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
            optional :sort_by, type: String, desc: '排序方式,多个排序字段用-隔开,默认倒序,需要正序加上.asc后缀 例如: created_at-price.asc-buy_count.asc'
            optional :subject, type: String, desc: '科目', values: APP_CONSTANT['subjects']
            optional :grade, type: String, desc: '年级', values: APP_CONSTANT['grades_in_menu']
            optional :price_floor, type: Integer, desc: '价格开始区间'
            optional :price_ceil, type: String, desc: '价格结束区间'
            optional :class_date_floor, type: String, desc: '开课日期结束区间'
            optional :class_date_ceil, type: String, desc: '开课日期结束区间'
            optional :status, type: String, desc: '辅导班状态 all: 全部; preview: 招生中; teaching: 已开课', values: %w(all preview teaching)
          end
          get do
            courses = LiveService::CourseDirector.courses_search(params).paginate(page: params[:page], per_page: params[:per_page])
            entity = current_user.student? ? Entities::LiveStudio::StudentCourse : Entities::LiveStudio::Course
            present courses, with: entity, type: :default, options: current_user
          end

          desc '检索辅导班详情接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, desc: '辅导班ID'
          end
          get '/:id' do
            course = ::LiveStudio::Course.find(params[:id])
            entity = current_user.student? ? Entities::LiveStudio::StudentCourse : Entities::LiveStudio::Course
            present course, with: entity, type: :full, options: current_user
          end

          desc '试听辅导班接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, desc: '辅导班ID'
          end
          get '/:id/taste' do
            course = ::LiveStudio::Course.find(params[:id])
            ticket = LiveService::CourseDirector.taste_course_ticket(current_user, course)
            present ticket, with: Entities::LiveStudio::Ticket
          end

          desc '辅导班直播信息' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, desc: '辅导班ID'
          end
          get '/:id/play_info' do
            # TODO 代码实现
            course = ::LiveStudio::Course.find(params[:id])
            present course, with: Entities::LiveStudio::StudentCourse, type: :full
          end
        end
      end
    end
  end
end
