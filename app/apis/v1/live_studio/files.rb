module V1
  # 线上课接口
  module LiveStudio
    class Files < V1::Base
      namespace "live_studio" do
        before do
          authenticate!
        end
        namespace :groups do
          route_param :group_id do
            resource :files do
              helpers do
                def auth_params
                  @group ||= ::LiveStudio::Group.find(params[:group_id])
                end

                def file_type(cate)
                  "Resource::#{cate.camelize}File"
                end
              end

              desc '课件列表' do
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
                quotes = @group.quotes.joins(:file)
                quotes = quotes.where('resource_files.type = Resource::DocumentFile', file_type(params[:cate])) if params[:cate].present?
                quotes = quotes.paginate(page: params[:page], per_page: params[:per_page])
                present quotes, with: Entities::Resource::Quote
              end

              desc '增加课件' do
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

              desc '删除课件' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                requires :group_id, type: Integer, desc: '专属课ID'
                requires :id, type: Integer, desc: '文件ID'
              end
              delete '/:id' do
                file = current_user.files.find(params[:id])
                @group.files.delete(file)
                { result: 'ok' }
              end
            end
          end
        end
      end
    end
  end
end
