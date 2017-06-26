module V1
  module LiveStudio
    module Students
      class Schedule < V1::Base
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

              desc '新学生课程表接口' do
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
                search_data = LiveService::SearchSchedule.new(@student)
                arr = search_data.search(params)

                present arr, with: Entities::LiveStudio::StudentSearchSchedule
              end
            end
          end
        end
      end
    end
  end
end
