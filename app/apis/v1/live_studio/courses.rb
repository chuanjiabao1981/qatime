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
            resource :courses do
              desc '辅导班列表接口' do
                headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                }
              end
              params do
                optional :page, type: Integer
                optional :per_page, type: Integer
              end
              get do
                courses = current_user.live_studio_courses
                present courses, with: Entities::LiveStudio::Course, type: :default
              end

              desc '辅导班全信息接口' do
                headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                }
              end
              params do
                optional :page, type: Integer
                optional :per_page, type: Integer
              end
              get :full do
                courses = current_user.live_studio_courses
                present courses, with: Entities::LiveStudio::Course, type: :full
              end

              desc '辅导班详情接口' do
                headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                }
              end
              params do
                requires :id, type: Integer, desc: '辅导班ID'
                optional :page, type: Integer
                optional :per_page, type: Integer
              end
              get 'courses/:id' do
                course = current_user.live_studio_courses.find(params[:id])
                present course, with: Entities::LiveStudio::Course, type: :full
              end
            end


            desc '直播开始接口' do
              headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
              }
            end
            params do
              requires :lesson_id, type: Integer, desc: '课程ID'
            end
            get :live_start do
              @lesson = ::LiveStudio::Lesson.find(params[:lesson_id])
              raise_change_error_for(@lesson.ready? || @lesson.paused? || @lesson.closed?)
              LiveService::LessonDirector.new(@lesson).lesson_start
              @lesson.current_live_session.token
              present @lesson, with: Entities::LiveStudio::Lesson, type: :live_start
            end

            desc '直播心跳通知接口' do
              headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
              }
            end
            params do
              requires :lesson_id, type: Integer, desc: '课程ID'
              optional :token, type: String, desc: '心跳token'
            end
            get :heartbeat do
              @lesson = ::LiveStudio::Lesson.find(params[:lesson_id])
              raise_change_error_for(@lesson.teaching? || @lesson.paused?)
              @lesson.heartbeats(params[:token])
              present @lesson, with: Entities::LiveStudio::Lesson, type: :live_start
            end

            desc '直播结束接口' do
              headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
              }
            end
            params do
              requires :lesson_id, type: Integer, desc: '课程ID'
            end
            get :live_end do
              @lesson = ::LiveStudio::Lesson.find(params[:lesson_id])
              raise_change_error_for(@lesson.teaching? || @lesson.paused?)
              @lesson.close!
              present @lesson, with: Entities::LiveStudio::Lesson, type: :live_start
            end
          end
        end

        namespace :students do
          # TODO 重复代码考虑放到上层作用域
          before do
            authenticate!
          end
          route_param :staudent_id do
            resource :courses do
              desc '学生我的辅导班接口' do
                headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                }
              end
              params do
                optional :page, type: Integer, desc: '当前页面'
                optional :per_page, type: Integer, desc: '每页记录数'
              end

              get do
                courses = LiveStudio::Course.last(20)
                present courses, with: Entities::LiveStudio::Course, type: :default
              end
            end
          end
        end

        resource :courses do
          desc '辅导班列表接口' do
            headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
            }
          end
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
            optional :sort_by, type: String, desc: '排序方式,多个排序字段用-隔开,默认倒序,需要正序加上.desc后缀 例如: created_at-price.asc-buy_count.asc'
            optional :subject, type: String, desc: '科目', values: APP_CONSTANT['subjects']
            optional :grade, type: String, desc: '年级', values: APP_CONSTANT['grades_in_menu']
            optional :price_floor, type: Integer, desc: '价格开始区间'
            optional :price_ceil, type: String, desc: '价格结束区间'
            optional :class_date_floor, type: String, desc: '开课日期结束区间'
            optional :class_date_ceil, type: String, desc: '开课日期结束区间'
            optional :status, type: String, desc: '辅导班状态 all: 全部; preview: 招生中; teaching: 已开课', values: %w(all preview teaching)
          end
          get do
            # TODO 分类查询
            courses = LiveStudio::Course.last(20)
            present courses, with: Entities::LiveStudio::Course, type: :default
          end

          desc '辅导班详情、辅导班列表、教师信息接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end

          params do
            requires :id, desc: '辅导班ID'
          end
          get '/:id' do
            # TODO 代码实现
            course = LiveStudio::Course.last
            present course, with: Entities::LiveStudio::Course, type: :full
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
            # TODO 代码实现
            course = LiveStudio::Ticket.last
            present course, with: Entities::LiveStudio::Ticket
          end
        end
      end
    end
  end
end
