module V1
  # 家庭作业接口
  module LiveStudio
    module Teachers
      class Homeworks < V1::Base
        namespace "live_studio" do
          namespace 'teachers' do
            before do
              authenticate!
            end
            route_param :teacher_id do
              helpers do
                def auth_params
                  @teacher ||= ::Teacher.find_by(id: params[:teacher_id])
                end
              end

              resource :homeworks do
                desc '已经布置的作业' do
                  headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
                end
                params do
                  requires :teacher_id, type: Integer, desc: '教师ID'
                  optional :page, type: Integer
                  optional :per_page, type: Integer
                end

                get '' do
                  homeworks = @teacher.live_studio_homeworks
                  homeworks = homeworks.paginate(page: params[:page], per_page: params[:per_page])
                  present homeworks, with: Entities::LiveStudio::Homework
                end
              end
            end
          end
        end
      end
    end
  end
end
