module V1
  # 模考接口
  module Exam
    class Results < V1::Base
      namespace "exam" do
        resource :papers do
          route_param :paper_id do
            helpers do
              def auth_params
                @paper ||= ::Exam::Paper.find(params[:paper_id])
              end
            end

            before do
              authenticate!
            end

            resource :results do
              desc '开始新的考试' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                requires :paper_id, type: Integer, desc: '试卷ID'
              end

              post do
                @ticket = current_user.exam_tickets.find_by!(product: @paper)
                result = current_user.exam_results.create(paper: @paper, ticket: @ticket)
                present result, with: Entities::Exam::ResultDetail
              end
            end
          end
        end

        resource :results do
          before do
            authenticate!
          end
          helpers do
            def auth_params
              @result ||= ::Exam::Result.find(params[:id])
            end
          end

          desc '交卷' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '答题卡ID'
            requires :answers_attributes, type: Array[Hash], coerce_with: JSON,
                     desc: '[{"topic_id": 10, "content", "xxxx", "attach": "xxxx_file.mp3"}, {"topic_id": 10, "content", "xxxx", "attach": "xxxx_file.mp3"}]'
          end

          put ':id' do
            result_params = ActionController::Parameters.new(params).permit(
              answers_attributes: [:topic_id, :content, :attach]
            )
            p result_params
            @result = current_user.exam_results.find(params[:id])
            @result.update(result_params)
            present @result, with: Entities::Exam::ResultDetail
          end
        end
      end
    end
  end
end
