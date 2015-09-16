class Solution < ActiveRecord::Base
  include QaToken

  belongs_to      :student
  belongs_to      :homework
  has_many        :pictures,as: :imageable,:dependent => :destroy
end
