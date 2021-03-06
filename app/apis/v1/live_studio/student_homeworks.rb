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
                student_homeworks = student_homeworks.includes(task_items: [:attachments], homework: [:user, task_items: [:attachments]], correction: [:user, task_items: [:attachments]])
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
          params do
            requires :id, type: Integer, desc: '学生作业ID'
            requires :task_items_attributes, type: Array[Hash], coerce_with: JSON,
                                             desc: '[{"parent_id": 1, "body": "不会", quotes_attributes: [{"id": 1, "attachment_id": 10, "_destroy": 1 }}, {"parent_id": 2, "body": "不会"}, {"parent_id": 3, "body": "不会" }]'
          end
          patch ':id' do
            student_homework_params = ActionController::Parameters.new(params).permit(task_items_attributes: [:parent_id, :body, quotes_attributes: [:id, :attachment_id, :_destroy]])
            raise ActiveRecord::RecordInvalid, @student_homework unless @student_homework.update(student_homework_params)
            present @student_homework, with: Entities::LiveStudio::StudentHomework
          end

          desc '学生作业详情' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '学生作业ID'
          end
          get ':id' do
            present @student_homework, with: Entities::LiveStudio::StudentHomework
          end
        end
      end
    end
  end
end
