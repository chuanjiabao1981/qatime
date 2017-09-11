module V1
  # 家庭作业接口
  module LiveStudio
    module Teachers
      class StudentHomeworks < V1::Base
        namespace "live_studio" do
          namespace 'teachers' do
            before do
              authenticate!
            end
            route_param :teacher_id do
              helpers do
                def auth_params
                  @teacher ||= ::Teacher.find_by(id: params[:teacher_id])
                end
              end
              resource :student_homeworks do
                desc '学生提交的作业' do
                  headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
                end
                params do
                  requires :teacher_id, type: Integer, desc: '教师ID'
                  requires :status, type: String, desc: '作业状态', values: "submitted: 待批改, resolved: 已批改"
                  optional :page, type: Integer
                  optional :per_page, type: Integer
                end

                get '' do
                  status = params[:status] = 'submitted'
                  student_homeworks = @teacher.live_studio_student_homeworks.where(status: status)
                  student_homeworks = student_homeworks.paginate(page: params[:page], per_page: params[:per_page])
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
