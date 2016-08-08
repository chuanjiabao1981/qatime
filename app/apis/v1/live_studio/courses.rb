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
                courses = current_user.live_studio_courses.uncompleted
                present courses, with: Entities::LiveStudio::TeacherCourse, type: :default
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
                courses = current_user.live_studio_courses.includes(:lessons).uncompleted
                present courses, with: Entities::LiveStudio::TeacherCourse, type: :full
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
                present course, with: Entities::LiveStudio::TeacherCourse, type: :full
              end
            end
          end
        end

        namespace :students do
          # TODO 重复代码考虑放到上层作用域
          before do
            authenticate!
          end
          route_param :student_id do
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
                optional :cate, type: String, desc: '分类 today: 今日; taste: 试听', values: %w(today taste)
                optional :status, type: String, desc: '辅导班状态 preview: 待开课; teaching: 已开课; completed: 已结束', values: %w(preview teaching completed)
              end
              get do
                courses = ::LiveStudio::Course.last(20)
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
            courses = ::LiveStudio::Course.last(20)
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
            course = ::LiveStudio::Course.last
            present course, with: Entities::LiveStudio::Course, type: :default
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
            course = ::LiveStudio::Ticket.last
            present course, with: Entities::LiveStudio::Ticket
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
            course = ::LiveStudio::Course.last
            present course, with: Entities::LiveStudio::StudentCourse, type: :full
          end
        end
      end
    end
  end
end
