module V1
  # 家庭作业接口
  module LiveStudio
    class StudentHomeworks < V1::Base
      namespace "live_studio" do
        before do
          authenticate!
        end
        namespace :groups do
          route_param :group_id do
            helpers do
              def auth_params
                @group ||= ::LiveStudio::CustomizedGroup.find(params[:group_id])
              end
            end

            resource :student_homeworks do
              desc '学生作业' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: false
                }
              end
              params do
                requires :group_id, type: Integer, desc: '专属课ID'
                optional :page, type: Integer, desc: '页码'
                optional :per_page, type: Integer, desc: '每页记录数'
              end
              get '' do
                student_homeworks =
                  if current_user.student?
                    @group.student_homeworks.where(user_id: current_user.id)
                  else
                    @group.student_homeworks.published
                  end
                student_homeworks = student_homeworks.includes(:task_items, homework: [:user, :task_items], correction: [:user, :task_items])
                student_homeworks = student_homeworks.paginate(page: params[:page], per_page: params[:per_page])
                present student_homeworks, with: Entities::LiveStudio::StudentHomework
              end
            end
          end
        end

        resource :student_homeworks do
          helpers do
            def auth_params
              @student_homework ||= ::LiveStudio::StudentHomework.find(params[:id])
            end
          end

          desc '学生提交作业' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          format :json
          params do
            requires :id
            requires :task_items_attributes, type: Array[JSON] do
              requires :parent_id, type: Integer, desc: '问题ID'
              requires :body, type: String, desc: '答案'
            end
          end

          patch ':id/update' do
            student_homework_params = ActionController::Parameters.new(params).permit(task_items_attributes: [:parent_id, :body])
            raise ActiveRecord::RecordInvalid, homework unless @student_homework.update(student_homework_params)
            @student_homework.submitted!
            present @student_homework, with: Entities::LiveStudio::StudentHomework
          end
        end
      end
    end
  end
end
