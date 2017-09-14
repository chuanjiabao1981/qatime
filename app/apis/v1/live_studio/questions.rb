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
                requires :body, type: String, desc: '问题内容'
              end

              post '' do
                question_params = ActionController::Parameters.new(params).permit(:title, :body)
                question = @group.questions.build(question_params)
                question.user = current_user
                raise ActiveRecord::RecordInvalid, question unless question.save
                present question, with: Entities::LiveStudio::Question
              end
            end
          end
        end
      end
    end
  end
end
