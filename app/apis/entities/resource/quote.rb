module Entities
  module Resource
    class Quote < Entities::Resource::File
      format_with(:local_timestamp, &:to_i)

      expose :file_id, as: :id
      expose :file_name, as: :name

      with_options(format_with: :local_timestamp) do
        expose :created_at
      end
    end
  end
end
