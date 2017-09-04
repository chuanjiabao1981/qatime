module Entities
  module Resource
    class File < Grape::Entity
      format_with(:local_timestamp, &:to_i)

      expose :id
      expose :name
      expose :type
      expose :file_size
      expose :ext_name
      expose :file_url
      with_options(format_with: :local_timestamp) do
        expose :created_at
      end
    end
  end
end
