module V1
  # 家庭作业接口
  module LiveStudio
    class Homeworks < V1::Base
      namespace "live_studio" do
        before do
          authenticate!
        end
        namespace :groups do
          route_param :group_id do
            resource :homeworks do
              helpers do
                def auth_params
                  @group ||= ::LiveStudio::Group.find(params[:group_id])
                end
              end

              desc '作业列表' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                requires :group_id, type: Integer, desc: '专属课ID'
              end
              get do
                homeworks = @group.homeworks
                homeworks = homeworks.paginate(page: params[:page], per_page: params[:per_page])
                present homeworks, with: Entities::LiveStudio::Homework
              end

              desc '添加作业' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                requires :group_id, type: Integer, desc: '专属课ID'
                requires :title, type: String, desc: '作业标题'
                requires :task_items_attributes, type: Array[Hash], coerce_with: JSON,
                                                 desc: '[{"body": "第一题"}, {"body": "第二题"}, {"body": "第三题" }]'
              end
              post do
                homework_params = ActionController::Parameters.new(params).permit(:title, task_items_attributes: [:body])
                homework = @group.homeworks.new(homework_params)
                homework.user = current_user
                raise ActiveRecord::RecordInvalid, homework unless homework.save
                present homework, with: Entities::LiveStudio::Homework
              end
            end
          end
        end

        resource :homeworks do
          helpers do
            def auth_params
              @homework = ::LiveStudio::Homework.find(params[:id])
            end
          end

          desc '作业详情' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '作业ID'
          end
          get ':id' do
            present @homework, root: :homework, with: Entities::LiveStudio::Homework
            if current_user.student?
              student_homework = @homework.student_homeworks.find_by(user_id: current_user.id)
              present student_homework, root: :student_homeworks, with: Entities::LiveStudio::StudentHomework
            else
              student_homeworks = @homework.student_homeworks.published.includes(:user, :task_items, correction: [:task_items])
              present student_homeworks, root: :student_homeworks, with: Entities::LiveStudio::StudentHomeworkList
            end
          end
        end
      end
    end
  end
end
