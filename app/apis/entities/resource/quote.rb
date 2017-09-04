module Entities
  module Resource
    class Quote < Grape::Entity
      format_with(:local_timestamp, &:to_i)

      expose :file do
        expose :id
        expose :name
        expose :type
        expose :file_size
        expose :ext_name
        expose :file_url
      end

      with_options(format_with: :local_timestamp) do
        expose :created_at
      end
    end
  end
end
