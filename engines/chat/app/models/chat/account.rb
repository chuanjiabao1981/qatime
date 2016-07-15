module Chat
  class Account < ActiveRecord::Base
    belongs_to :user, class_name: '::User'
    has_many :join_records
    has_many :teams, through: :join_records

    def icon_url
      icon.presence || "/imgs/no_header.png"
    end
  end
end
