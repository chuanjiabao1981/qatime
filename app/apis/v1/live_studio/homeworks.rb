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
                optional :cate, type: String, values: %w(video picture document other)
              end
              get do
                files = @group.files
                files = files.where(type: file_type(params[:cate])) if params[:cate].present?
                files = files.paginate(page: params[:page], per_page: params[:per_page])
                present files, with: Entities::Resource::File
              end

              desc '添加作业' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                requires :group_id, type: Integer, desc: '专属课ID'
                requires :file_id, type: Integer, desc: '文件ID'
              end
              post do
                file = current_user.files.find(params[:file_id])
                if @group.files.include?(file)
                  { result: 'fail' }
                else
                  @group.files << file
                  { result: 'ok' }
                end
              end
            end

            resource :student_homeworks do

            end
          end
        end
      end
    end
  end
end
