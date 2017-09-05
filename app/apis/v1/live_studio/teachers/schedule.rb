module V1
  module LiveStudio
    module Teachers
      class Schedule < V1::Base
        namespace "live_studio" do
          namespace :teachers do
            before do
              authenticate!
            end
            route_param :teacher_id do
              helpers do
                def auth_params
                  @teacher ||= ::Teacher.find_by(id: params[:teacher_id])
                end
              end

              desc '新老师课程表接口' do
                headers 'Remember-Token' => {
                            description: 'RememberToken',
                            required: true
                        }
              end
              params do
                optional :date_type, type: String, desc: '日期类型: month, week, 默认month', values: %w[month week]
                optional :date, type: String, desc: '日期: 2016-10-01, 默认今天'
                optional :state, type: String, desc: '课程状态:未上课 已上课 不传则默认返回全部', values: %w[unclosed closed]
              end
              get :schedule_data do
                search_data = LiveService::SearchSchedule.new(@teacher)
                arr = search_data.search_old(params)

                present arr, with: Entities::LiveStudio::TeacherSearchSchedule
              end
            end
          end
        end
      end
    end
  end
end
