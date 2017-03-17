module V1
  # 辅导班接口
  module LiveStudio
    class Courses < V1::Base
      namespace "live_studio" do

        namespace :teachers do
          before do
            authenticate!
          end

          route_param :teacher_id do
            helpers do
              def auth_params
                @teacher = ::Teacher.find_by(id: params[:teacher_id])
              end
            end

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
                optional :status, type: String, desc: '过滤条件 init:初始化; published: 待开课; teaching: 已开课; completed: 已结束; today: 今日有课的辅导班. 多个状态用英文逗号分隔'
              end
              get do
                courses = LiveService::CourseDirector.courses_for_teacher_index(current_user, params)
                                                     .paginate(page: params[:page], per_page: params[:per_page])
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
                optional :status, type: String, desc: '过滤条件 init:初始化; published: 待开课; teaching: 已开课; completed: 已结束; today: 今日有课的辅导班. 多个状态用英文逗号分隔'
              end
              get :full do
                courses = LiveService::CourseDirector.courses_for_teacher_index(current_user, params)
                                                     .paginate(page: params[:page], per_page: params[:per_page])
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
                optional :status, type: String, desc: '辅导班状态 published: 待开课; teaching: 已开课; completed: 已结束', values: %w(published teaching completed)
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
          before do
            authenticate!
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
                announcements: course.announcements.all.order(id: :desc),
                members: course.chat_team.try(:join_records).try(:map,&:account),
                current_lesson_status: course.current_lesson.try(:status),
                owner: course.chat_team.try(:owner).to_s
              }
            present realtime, with: Entities::CourseRealtime
          end

          desc '创建辅导班订单接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, desc: '辅导班ID'
            requires :pay_type, type: String, values: ::Payment::Order.pay_type.values, desc: '支付方式'
            optional :coupon_code, type: String, desc: '使用优惠码(可不填)'
          end
          post '/:id/orders' do
            course = ::LiveStudio::Course.find(params[:id])
            order = ::Payment::Order.new(course.order_params.merge(pay_type: params[:pay_type], remote_ip: client_ip, source: :app, user: current_user))
            if params[:coupon_code].present?
              coupon = ::Payment::Coupon.find_by(code: params[:coupon_code])
              order.amount = course.coupon_price(coupon)
              order.coupon = coupon
            end
            order.save

            raise ActiveRecord::RecordInvalid, order if order.errors.any?
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
            # 临时解决方案
            @paly_records = current_user.nil? ? [] : ::LiveStudio::PlayRecord.where(lesson_id: course.lessons.map(&:id),
                                                                             play_type: ::LiveStudio::PlayRecord.play_types[:replay],
                                                                             user_id: current_user.id).to_a
            course.lessons.each do |l|
              l.replay_times = @paly_records.select {|record| record.lesson_id == l.id }.count
            end
            present course, with: Entities::LiveStudio::StudentCourse, type: :full, current_user: current_user,size: :info
          end

          desc '录制视频列表' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, desc: '辅导班ID'
          end
          get '/:id/replays' do
            @course = ::LiveStudio::Course.find(params[:id])
            info = {
              id: @course.id,
              lessons: @course.lessons
            }
            present info, with: Entities::LiveStudio::CourseReplay, current_user: current_user
          end
        end

        resource :courses do
          desc '检索辅导班列表接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
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
            optional :status, type: String, desc: '辅导班状态 all: 全部; published: 招生中; teaching: 已开课', values: %w(all published teaching)
            optional :class_date_floor, type: String, desc: '开课日期开始时间'
            optional :class_date_ceil, type: String, desc: '开课日期结束时间'
            optional :city_name, type: String, desc: '限定城市名称'
          end
          get do
            courses = LiveService::CourseDirector.courses_search(params).paginate(page: params[:page], per_page: params[:per_page])
            present courses, with: Entities::LiveStudio::SearchCourse, type: :default, current_user: current_user
          end

          desc '搜索辅导班' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
            optional :range, type: String, values: %w(1_months 2_months 3_months 6_months 1_year), desc: '查询区间'
            optional :status_eq, type: String, desc: '辅导班状态 all: 全部; published: 招生中; teaching: 已开课', values: %w(all published teaching)
            optional :grade_eq, type: String, desc: '年级', values: APP_CONSTANT['grades_in_menu']
            optional :subject_eq, type: String, desc: '科目', values: APP_CONSTANT['subjects']
            optional :class_date_gteq, type: String, desc: '开课日期开始时间'
            optional :class_date_lt, type: String, desc: '开课日期结束时间'
            optional :tags, type: String, desc: '标签'
            optional :sort_by, type: String, desc: '排序方式', values: %w(price price.asc published_at published_at.asc users_count users_count.asc)
          end
          get 'search' do
            search_params[:q] = params.slice(:range, :status_eq, :grade_eq, :subject_eq, :class_date_gteq, :class_date_lt)
            search_params[:q][:s] =
              if params[:sort_by]
                by, direction = params[:sort_by].split('.')
                "#{by}+#{direction || 'desc'}"
              else
                'published_at+desc'
              end
            search_params[:tags] = params[:tags]
            q = LiveService::CourseDirector.courses_search(search_params)
            courses = q.result.paginate(page: params[:page], per_page: params[:per_page])
            present courses, with: Entities::LiveStudio::SearchCourse, type: :default, current_user: current_user
          end

          desc '检索辅导班详情接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            requires :id, desc: '辅导班ID'
          end
          get '/:id' do
            course = ::LiveStudio::Course.find(params[:id])

            # 临时解决方案
            @paly_records = current_user.nil? ? [] : ::LiveStudio::PlayRecord.where(lesson_id: course.lessons.map(&:id),
                                                                             play_type: ::LiveStudio::PlayRecord.play_types[:replay],
                                                                             user_id: current_user.id).to_a
            course.lessons.each do |l|
              l.replay_times = @paly_records.select {|record| record.lesson_id == l.id }.count
            end

            present course, with: Entities::LiveStudio::StudentCourse, type: :full, current_user: current_user, size: :info
          end
        end

        namespace :courses do
          before do
            authenticate!
          end

          route_param :course_id do
            helpers do
              def auth_params
                @course = ::LiveStudio::Course.find(params[:course_id])
                @course.teacher
              end
            end

            desc '辅导班发布公告' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :content, type: String, desc: "公告内容"
            end
            post 'announcements' do
              unless @course.chat_team
                ::LiveService::ChatTeamManager.new(nil).instance_team(@course)
                @course.reload
              end
              @announcement = @course.announcements.new(content: params[:content], lastest: true, creator: @course.teacher)
              if @announcement.save
                @course.announcements.where(lastest: true).where("id <> ?", @announcement).update_all(lastest: false)
              end
              "ok"
            end

            desc '直播状态查询' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :course_id, type: Integer, desc: '辅导班ID'
            end
            get 'live_status' do
              @course = ::LiveStudio::Course.find(params[:course_id])
              LiveService::CourseDirector.new(@course).stream_status
            end
          end
        end
      end
    end
  end
end
