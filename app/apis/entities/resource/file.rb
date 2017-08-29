module Entities
  module Resource
    class File < Grape::Entity
      expose :id
      expose :name
      expose :type
      expose :file_size
      expose :ext_name
    end
  end
end
