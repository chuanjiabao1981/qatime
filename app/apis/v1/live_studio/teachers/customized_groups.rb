module V1
  # 一对一直播接口
  module LiveStudio
    module Teachers
      class CustomizedGroups < V1::Base
        namespace "live_studio" do
          before do
            authenticate!
          end
          namespace :teachers do
            route_param :teacher_id do
              helpers do
                def auth_params
                  @teacher ||= ::Teacher.find_by(id: params[:teacher_id])
                end
              end
              resource :customized_groups do
                desc '我的专属课' do
                  headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
                end
                params do
                  requires :teacher_id, type: Integer
                  optional :page, type: Integer
                  optional :per_page, type: Integer
                  requires :status,
                           type: String,
                           default: 'published',
                           desc: '状态 published: 招生中; teaching: 开课中; completed: 已结束; 多个用逗号分隔'
                end
                get do
                  status = ::LiveStudio::CustomizedGroup.statuses.values_at(*params[:status].split(/[\s,]+/))
                  groups = @teacher.live_studio_customized_groups.where(status: status)
                  groups = groups.paginate(page: params[:page], per_page: params[:per_page])
                  present groups, with: Entities::LiveStudio::TeacherGroup
                end
              end
            end
          end

          resource :customized_groups do
            helpers do
              def auth_params
                @group ||= ::LiveStudio::CustomizedGroup.find(params[:id])
              end
            end

            desc '直播上课信息' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :id, type: Integer
            end
            get ':id/live' do
              present @group, with: Entities::LiveStudio::GroupLiveDetail
            end
          end
        end
      end
    end
  end
end
