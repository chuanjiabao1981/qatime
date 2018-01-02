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
                optional :status, type: String, desc: '过滤条件 published: 待开课; teaching: 已开课; completed: 已结束; today: 今日有课的辅导班. 多个状态用英文逗号分隔'
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
                optional :status, type: String, desc: '过滤条件 published: 待开课; teaching: 已开课; completed: 已结束; today: 今日有课的辅导班. 多个状态用英文逗号分隔'
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
              optional :week, type: String, desc: '本周内: 2016-10-01 返回本周7天的数据'
              optional :month, type: String, desc: '月份: 2016-10-01 该值为空则默认返回当月数据'
              optional :state, type: String, desc: '课程状态:未上课 已完成 不传则默认返回全部', values: %w(unclosed closed)
            end
            get 'schedule' do
              if params[:week].present?
                arr = LiveService::CourseDirector.courses_by_week(current_user, params[:week], params[:state])
              else
                arr = LiveService::CourseDirector.courses_by_month(current_user, params[:month], params[:state])
              end
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

          desc '购买免费的直播课(无需下单直接出票)' do
            headers 'Remember-Token' => {
                        description: 'RememberToken',
                        required: true
                    }
          end
          params do
            requires :id, desc: '直播课ID'
          end
          post '/:id/deliver_free' do
            course = ::LiveStudio::Course.find(params[:id])
            ticket = course.free_grant(current_user) if current_user.student?
            raise ActiveRecord::RecordNotFound if ticket.blank?
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
            order = ::Payment::Order.new(course.order_params.merge(pay_type: params[:pay_type],
                                                                   remote_ip: client_ip,
                                                                   source: :student_app, user: current_user))
            order.use_coupon(params[:coupon_code])
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
            user = course.sell_type.free? ? nil : current_user
            present course, with: Entities::LiveStudio::StudentCourse, type: :full, current_user: user, size: :info
          end

          desc '加入课程' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, desc: '辅导班ID'
          end
          get '/:id/join' do
            @course = ::LiveStudio::Course.find(params[:id])
            if @course.bought_by?(current_user)
              @chat_team = @course.chat_team || LiveService::ChatTeamManager.new(nil).instance_team(@course, @course.teacher.chat_account)
              @chat_account = current_user.try(:chat_account)
              if @chat_account.nil?
                @chat_account = LiveService::ChatAccountFromUser.new(current_user).instance_account
              end
            end
            @join_record = @chat_team.join_records.find_by(account_id: @chat_account.id) || LiveService::ChatTeamManager.new(@chat_team).add_to_team([@chat_account], 'normal').first
            { result: 'ok' }
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

          desc '搜索直播课' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
            optional :tags, type: String, desc: '标签'
            optional :range, type: String, values: %w(1_months 2_months 3_months 6_months 1_year), desc: '查询区间'
            optional :q, type: Hash, default: {} do
              optional :status_eq, type: String, desc: '辅导班状态 all: 全部; published: 招生中; teaching: 已开课', values: %w(all published teaching)
              optional :grade_eq, type: String, desc: '年级', values: APP_CONSTANT['grades_in_menu']
              optional :subject_eq, type: String, desc: '科目', values: APP_CONSTANT['subjects']
              optional :sell_type_eq, type: String, desc: '销售类型 charge: 收费; free: 免费', values: %w[charge free]
              optional :class_date_gteq, type: String, desc: '开课日期开始时间'
              optional :class_date_lt, type: String, desc: '开课日期结束时间'
            end
            optional :sort_by, type: String, desc: '排序方式', values: %w(left_price left_price.asc published_at published_at.asc users_count users_count.asc buy_tickets_count buy_tickets_count.asc)
          end
          get 'search' do
            search_params = ActionController::Parameters.new(params).permit(:tags, :range, :sort_by, q: [:status_eq, :grade_eq, :subject_eq, :sell_type_eq, :class_date_gteq, :class_date_lt])
            search_params[:q][:status_eq] = ::LiveStudio::Course.statuses[search_params[:q][:status_eq]] if search_params[:q][:status_eq].present?
            search_params[:q][:sell_type_eq] = ::LiveStudio::Course.sell_type.find_value(search_params[:q][:sell_type_eq]).try(:value) if search_params[:q][:sell_type_eq].present?
            search_params[:q][:s] =
              if search_params[:sort_by].present?
                by, direction = search_params[:sort_by].split('.')
                "#{by} #{direction || 'desc'}"
              else
                'published_at desc'
              end
            q = LiveService::CourseDirector.search(search_params)
            courses = q.result.paginate(page: params[:page], per_page: params[:per_page])
            present courses, with: Entities::LiveStudio::SearchCourse, type: :default, current_user: current_user
          end

          desc '检索直播课详情接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            requires :id, desc: '直播课ID'
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

          desc '新直播课详情' do
            headers 'Remember-Token' => {
                        description: 'RememberToken',
                        required: false
                    }
          end
          params do
            requires :id, type: Integer, desc: 'ID'
          end
          get ':id/detail' do
            course = ::LiveStudio::Course.find(params[:id])
            ticket = course.tickets.available.find_by(student: current_user) if current_user


            # 临时解决方案
            @paly_records = current_user.nil? ? [] : ::LiveStudio::PlayRecord.where(lesson_id: course.lessons.map(&:id),
                                                                             play_type: ::LiveStudio::PlayRecord.play_types[:replay],
                                                                             user_id: current_user.id).to_a
            course.lessons.each do |l|
              l.replay_times = @paly_records.select {|record| record.lesson_id == l.id }.count
            end
            

            present course, root: :course, with: Entities::LiveStudio::CourseDetail
            present ticket, root: :ticket, with: Entities::LiveStudio::CourseTicket, type: :full
          end

          desc '成员列表' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            requires :id, type: Integer, desc: 'ID'
          end
          get ':id/members' do
            course = ::LiveStudio::Course.find(params[:id])
            members = course.buy_tickets.includes(:student)
            present course.teachers, root: :teachers, with: Entities::User
            present members, root: :members, with: Entities::LiveStudio::CourseMember
          end

          desc '辅导班排行'
          params do
            requires :names, type: String, desc: '排行名称多个获逗号分隔 published_rank: 最新发布; start_rank: 最近开课;'
            optional :count, type: Integer, desc: '记录数'
          end
          get '/rank/:names' do
            params[:names].split(/，\s*|,\s*/).each do |rank_name|
              courses = ::LiveService::RankManager.rank_of(rank_name).limit(params[:count])
              present courses, with: ::Entities::LiveStudio::Course, root: rank_name
            end
          end

          desc '直播课,一对一,视频课,小班课排行'
          params do
            requires :name, type: String, desc: 'all_published_rank: 最新发布', values: %w[all_published_rank]
            optional :city_id, type: Integer, desc: '城市ID'
            optional :count, type: Integer, desc: '记录数'
          end
          get '/rank_all/:name' do
            courses = ::LiveService::RankManager.rank_of('all_published_rank_old', {city_id: params[:city_id], limit: params[:count]})
            present courses, with: ::Entities::LiveStudio::RankAllCourse, root: params[:name]
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

            desc '新的直播状态查询' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :course_id, type: Integer, desc: '辅导班ID'
            end
            get 'status' do
              LiveService::RealtimeService.new(params[:course_id]).live_detail(current_user.try(:id))
            end
          end
        end

        desc '直播状态批量查询'
        params do
          optional :lesson_ids, type: String, desc: '课程ID用英文逗号或者中划线隔开'
          optional :course_ids, type: String, desc: '辅导班ID用英文逗号或者中划线隔开'
          exactly_one_of :lesson_ids, :course_ids
        end
        get 'status' do
          result =
            if params[:lesson_ids].present?
              ::LiveStudio::Lesson.where(id: params[:lesson_ids].split(/\s*[-;]\s*/)).map {|lesson| [lesson.id, lesson.status]}
            else
              ::LiveStudio::Course.includes(:lessons).where(id: params[:course_ids].split(/\s*[-;]\s*/)).map {|course| [course.id, course.live_status]}
            end
          result
        end

        desc '免费课程'
        params do
          optional :count, type: Integer, desc: '记录数'
        end
        get 'free_courses' do
          home_data = DataService::HomeData.new
          free_courses = home_data.free_courses_old(limit: params[:count].presence)
          present free_courses, with: Entities::LiveStudio::FreeCourse
        end
      end
    end
  end
end
