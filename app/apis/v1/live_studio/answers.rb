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
                requires :question_id, type: Integer, desc: '专属课ID'
                requires :body, type: String, desc: '回答内容'
              end
              post '' do
                answer_params = ActionController::Parameters.new(params).permit(:body)
                answer = @question.answer || @question.build_answer(answer_params)
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
            requires :body, type: String, desc: '回答内容'
          end

          patch ':id' do
            answer_params = ActionController::Parameters.new(params).permit(:body)
            raise ActiveRecord::RecordInvalid, @answer unless @answer.update(answer_params)
            present @answer, with: Entities::LiveStudio::Answer
          end
        end
      end
    end
  end
end
