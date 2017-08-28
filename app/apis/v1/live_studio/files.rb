module V1
  # 线上课接口
  module LiveStudio
    class Files < V1::Base
      namespace "live_studio" do
        before do
          authenticate!
        end

        route_param :event_id do
          helpers do
            def auth_params
              @event ||= ::LiveStudio::Event.find(params[:event_id])
            end

            def file_type(cate)
              "Resource::#{cate.camelize}File"
            end
          end

          resource :files do
            desc '文件列表' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :event_id, type: Integer, desc: '专属课ID'
              optional :cate, type: String, values: %w(video picture document other)
            end
            get do
              files = @event.files
              files = files.where(type: file_type(params[:cate])) if params[:cate].present?
              files = files.paginate(page: params[:page], per_page: params[:per_page])
              present files, with: Entities::Resource::File
            end
          end
        end
      end
    end
  end
end
