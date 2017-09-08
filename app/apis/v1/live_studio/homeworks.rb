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
              end
              post do
                homework = @taskable.homeworks.new(homework_params)
                homework.user = current_user
                raise ActiveRecord::RecordInvalid, homework unless homework.save
                present homework, with: Entities::LiveStudio::Homework
              end
            end
          end
        end
      end
    end
  end
end
