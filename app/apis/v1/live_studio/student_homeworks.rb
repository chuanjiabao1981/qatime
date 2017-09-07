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
            resource :student_homeworks do

            end
          end
        end
      end
    end
  end
end
