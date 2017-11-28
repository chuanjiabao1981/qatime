module V1
  # 提问
  module LiveStudio
    class Answers < V1::Base
      namespace "live_studio" do
        before do
          authenticate!
        end
        namespace :questions do
          route_param :question_id do
            helpers do
              def auth_params
                @question ||= ::LiveStudio::Question.find(params[:question_id])
              end
            end

            resource :answers do
              desc '老师回答问题' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: false
                }
              end
              params do
                requires :question_id, type: Integer, desc: '小班课ID'
                optional :body, type: String, desc: '回答内容'
                optional :quotes_attributes,
                         type: Array[Hash],
                         coerce_with: JSON,
                         desc: '[{"attachment_id": 10}, {"attachment_id": 11}, {"attachment_id": 12}]'
              end
              post '' do
                answer_params = ActionController::Parameters.new(params).permit(:body, quotes_attributes: [:attachment_id])
                answer = @question.answers.build(answer_params)
                answer.user ||= current_user
                raise ActiveRecord::RecordInvalid, answer unless answer.save
                present answer, with: Entities::LiveStudio::Answer
              end
            end
          end
        end

        resources :answers do
          helpers do
            def auth_params
              @answer ||= ::LiveStudio::Answer.find(params[:id])
            end
          end

          desc '老师修改回答' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '回答ID'
            optional :body, type: String, desc: '回答内容'
            optional :quotes_attributes,
                     type: Array[Hash],
                     coerce_with: JSON,
                     desc: '[{"attachment_id": 10}, {"attachment_id": 11}, {"attachment_id": 12}]'
          end

          patch ':id' do
            answer_params = ActionController::Parameters.new(params).permit(:body, quotes_attributes: [:id, :attachment_id, :_destroy])
            raise ActiveRecord::RecordInvalid, @answer unless @answer.update(answer_params)
            present @answer, with: Entities::LiveStudio::Answer
          end
        end
      end
    end
  end
end
