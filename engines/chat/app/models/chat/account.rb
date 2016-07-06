module Chat
  class Account < ActiveRecord::Base

    has_one :join_record

  end
end
