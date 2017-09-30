module V1
  # 提问
  module LiveStudio
    class Questions < V1::Base
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

            resource :questions do
              desc '提问列表' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: false
                }
              end
              params do
                requires :group_id, type: Integer, desc: '专属课ID'
                optional :user_id, type: Integer, desc: '学生ID'
                optional :page, type: Integer, desc: '页码'
                optional :per_page, type: Integer, desc: '每页记录数'
              end
              get '' do
                questions = @group.questions
                questions = questions.where(user_id: params[:user_id]) if params[:user_id].present?
                present questions, with: Entities::LiveStudio::Question
              end

              desc '学生提问' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                requires :group_id, type: Integer, desc: '专属课ID'
                requires :title, type: String, desc: '问题标题'
                optional :body, type: String, desc: '问题内容'
                optional :quotes_attributes,
                         type: Array[Hash],
                         coerce_with: JSON,
                         desc: '[{"attachment_id": 10}, {"attachment_id": 11}, {"attachment_id": 12}]'
              end
              post '' do
                question_params = ActionController::Parameters.new(params).permit(:title, :body, quotes_attributes: [:attachment_id])
                question = @group.questions.build(question_params)
                question.user = current_user
                raise ActiveRecord::RecordInvalid, question unless question.save
                present question, with: Entities::LiveStudio::Question
              end
            end
          end
        end

        resource :questions do
          helpers do
            def auth_params
              @question ||= ::LiveStudio::Question.find(params[:id])
            end
          end

          desc '提问详情' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            requires :id, type: Integer, desc: '问题ID'
          end
          get ':id' do
            present @question, with: Entities::LiveStudio::Question
          end
        end
      end
    end
  end
end
