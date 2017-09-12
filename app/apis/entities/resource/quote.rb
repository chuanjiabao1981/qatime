module Entities
  module Resource
    class Quote < File
      format_with(:local_timestamp, &:to_i)

      expose :file_id, as: :id

      with_options(format_with: :local_timestamp) do
        expose :created_at
      end
    end
  end
end
