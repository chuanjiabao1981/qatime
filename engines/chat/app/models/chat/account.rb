module Chat
  class Account < ActiveRecord::Base

    belongs_to :user, class_name: '::User'
    has_one :join_record

  end
end
