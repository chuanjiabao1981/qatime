module Payment
  class RemoteOrder < ActiveRecord::Base
    belongs_to :order, polymorphic: true
  end
end
