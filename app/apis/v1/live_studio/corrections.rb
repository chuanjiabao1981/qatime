module V1
  # 家庭作业批改接口
  module LiveStudio
    class Corrections < V1::Base
      namespace "live_studio" do
        before do
          authenticate!
        end
        namespace :student_homeworks do
          route_param :student_homework_id do
            helpers do
              def auth_params
                @student_homework ||= ::LiveStudio::StudentHomework.find(params[:student_homework_id])
              end
            end

            resource :corrections do
              desc '作业批改' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: false
                }
              end
              params do
                requires :student_homework_id, type: Integer, desc: '学生提交的作业ID'
                requires :task_items_attributes, type: Array[Hash], coerce_with: JSON,
                         desc: '[{"parent_id": 45, "body": "45修改", "quotes_attributes": [{"attachment_id": 10}]}, {"parent_id": 46, "body": "46修改"}, {"parent_id": 47, "body": "47修改" }]'
              end
              post '' do
                correction_params = ActionController::Parameters.new(params).permit(task_items_attributes: [:parent_id, :body, quotes_attributes: [:attachment_id]])
                correction = @student_homework.corrections.build(correction_params)
                correction.user = current_user
                raise ActiveRecord::RecordInvalid, correction unless correction.save
                present correction, with: Entities::LiveStudio::Correction
              end
            end
          end
        end

        resource :corrections do
          helpers do
            def auth_params
              @correction ||= ::LiveStudio::Correction.find(params[:id])
            end
          end

          desc '作业重新批改' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            requires :id, type: Integer, desc: '旧的批改ID'
            requires :task_items_attributes, type: Array[Hash], coerce_with: JSON, desc: '[{"id": 45, "body": "45修改", "quotes_attributes": [{"attachment_id": 10}]}, {"id": 46, "body": "46修改"}, {"id": 47, "body": "47修改" }]'
          end
          patch ':id' do
            correction_params = ActionController::Parameters.new(params).permit(task_items_attributes: [:id, :body, quotes_attributes: [:id, :attachment_id, :_destroy]])
            raise ActiveRecord::RecordInvalid, @correction unless @correction.update(correction_params)
            present @correction, with: Entities::LiveStudio::Correction
          end
        end
      end
    end
  end
end
