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
                present course, with: Entities::LiveStudio::TeacherCourse, type: :full, size: :info
              end
            end

            desc '老师课程表接口' do
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
            optional :price_ceil, type: Integer, desc: '价格结束区间'
            optional :class_date_floor, type: String, desc: '开课日期结束区间'
            optional :class_date_ceil, type: String, desc: '开课日期结束区间'
            optional :preset_lesson_count_floor, type: Integer, desc: '课时总数开始区间'
            optional :preset_lesson_count_ceil, type: Integer, desc: '课时总数结束区间'
            optional :status, type: String, desc: '辅导班状态 all: 全部; preview: 招生中; teaching: 已开课', values: %w(all preview teaching)
          end
          get do
            courses = LiveService::CourseDirector.courses_search(params).paginate(page: params[:page], per_page: params[:per_page])
            entity = current_user.student? ? Entities::LiveStudio::StudentCourse : Entities::LiveStudio::Course
            present courses, with: entity, type: :default, current_user: current_user
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
            present course, with: entity, type: :full, current_user: current_user, size: :info
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

          desc '公告 成员状态 直播列表' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, desc: '辅导班ID'
          end
          get '/:id/realtime' do
            course = ::LiveStudio::Course.find(params[:id])
            realtime =
              {
                announcements: course.chat_team.try(:team_announcements).try(:order, created_at: :desc),
                members: course.chat_team.try(:join_records).try(:map,&:account),
                current_lesson_status: course.current_lesson.try(:status)
              }
            present realtime,with: Entities::CourseRealtime
          end

          desc '创建辅导班订单接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, desc: '辅导班ID'
            requires :pay_type, type: Integer, desc: '支付方式 0: 支付宝; 1: 微信', values: Payment::Order::PAY_TYPE.values
          end
          post '/:id/orders' do
            course = ::LiveStudio::Course.find(params[:id])
            order_params = {
              trade_type: "APP", pay_type: params[:pay_type], remote_ip: headers['X-Real-Ip'] || env["REMOTE_ADDR"]
            }
            order = LiveService::CourseDirector.create_order(current_user, course, order_params)
            order.init_remote_order if order.unpaid? && order.prepay_id.blank?
            present order, with: Entities::Payment::Order
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
            course = ::LiveStudio::Course.find(params[:id])
            present course, with: Entities::LiveStudio::StudentCourse, type: :full, current_user: current_user,size: :info
          end
        end
      end
    end
  end
end
