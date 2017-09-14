module V1
  # 提问
  module LiveStudio
    module Students
      class Questions < V1::Base
        namespace "live_studio" do
          namespace :students do
            before do
              authenticate!
            end
            route_param :student_id do
              helpers do
                def auth_params
                  @student ||= ::Student.find(params[:student_id])
                end
              end

              resource :questions do
                desc '学生个人中心提问列表' do
                  headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: false
                  }
                end
                params do
                  requires :student_id, type: Integer, desc: '学生ID'
                  optional :status, type: String, desc: '提问状态', values: %w(pending resolved)
                  optional :page, type: Integer, desc: '页码'
                  optional :per_page, type: Integer, desc: '每页记录数'
                end
                get '' do
                  questions = @student.live_studio_questions
                  questions = questions.where(status: ::LiveStudio::Question.statuses[params[:status]]) if params[:status].present?
                  questions = questions.paginate(page: params[:page], per_page: params[:per_page])
                  present questions, with: Entities::LiveStudio::Question
                end
              end
            end
          end
        end
      end
    end
  end
end
