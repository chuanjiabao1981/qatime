class Setting < ApplicationRecord
  belongs_to :owner, polymorphic: true
end
