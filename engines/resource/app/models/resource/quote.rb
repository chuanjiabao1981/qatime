module Resource
  class Quote < ActiveRecord::Base
    belongs_to :file, counter_cache: true
    belongs_to :quoter, polymorphic: true

    delegate :name, :type, :file_size, :ext_name, :file_url, to: :file

    def file_id
      file.try(:id)
    end
  end
end
