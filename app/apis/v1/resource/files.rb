module V1
  module Resource
    class Files < V1::Base
      namespace "resource" do
        resource :files do
          before do
            authenticate!
          end

          helpers do
            def file_params
              ActionController::Parameters.new(params).permit(:tags, :range, :sort_by)
            end
          end

          route_param :id do
            helpers do
              def auth_params
                @file ||= ::Resource::File.find(params[:id])
              end
            end

            desc '文件详情' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :id, type: Integer
            end
            get do
              present @file, with: Entities::Resource::File
            end

            desc '文件删除' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :id, type: Integer
            end
            delete do
              current_user.files.delete(@file)
              { result: 'ok' }
            end
          end

          desc '文件上传' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :file, type: ::File
          end
          post do
            attach = ::Resource::Attach.create!(file: params[:file])
            file = current_user.files.create(
              name: params[:file][:filename],
              user: current_user,
              attach: attach,
              ext_name: attach.ext_name,
              file_size: attach.file_size,
              type: attach.resource_type
            )
            present file, with: Entities::Resource::File
          end
        end
      end
    end
  end
end
