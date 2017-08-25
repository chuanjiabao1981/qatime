module V1
  module Resource
    module Teachers
      class Files < V1::Base
        namespace "resource" do
          namespace 'teachers' do
            before do
              authenticate!
            end
            route_param :teacher_id do
              helpers do
                def auth_params
                  @teacher ||= ::Teacher.find_by(id: params[:teacher_id])
                end

                def file_type(cate)
                  "Resource::#{cate.camelize}File"
                end
              end

              resource :files do
                desc '我的文件' do
                  headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
                end
                params do
                  requires :teacher_id, type: Integer
                  optional :page, type: Integer
                  optional :per_page, type: Integer
                  optional :cate, type: String, values: %w(video picture document other)
                end
                get do
                  files = @teacher.files
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
  end
end
