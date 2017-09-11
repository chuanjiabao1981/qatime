module V1
  # 家庭作业接口
  module LiveStudio
    module Students
      class StudentHomeworks < V1::Base
        namespace "live_studio" do
          namespace 'students' do
            before do
              authenticate!
            end
            route_param :student_id do
              helpers do
                def auth_params
                  @student ||= ::Student.find_by(id: params[:student_id])
                end
              end
              resource :student_homeworks do
                desc '我的作业' do
                  headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
                end
                params do
                  requires :student_id, type: Integer, desc: '教师ID'
                  requires :status, type: String, desc: '作业状态', values: "pending: 未做, submitted: 待批, resolved: 已批"
                  optional :page, type: Integer
                  optional :per_page, type: Integer
                end

                get '' do
                  status = params[:status] = 'pending'
                  student_homeworks = @student.live_studio_student_homeworks.where(status: status).paginate(page: params[:page], per_page: params[:per_page])
                  present student_homeworks, with: Entities::LiveStudio::StudentHomework
                end
              end
            end
          end
        end
      end
    end
  end
end
