module Resource
  class Quote < ActiveRecord::Base
    belongs_to :file, counter_cache: true
    belongs_to :quoter, polymorphic: true

    delegate :type, :file_size, :ext_name, :file_url, to: :file
    delegate :name, to: :file, prefix: true
  end
end
