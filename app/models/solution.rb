class Solution < ActiveRecord::Base
  include QaToken
  include ContentValidate
  belongs_to      :student
  belongs_to      :homework,:counter_cache => true
  has_many        :pictures,as: :imageable,:dependent => :destroy
  has_many        :corrections,:dependent => :destroy
  has_many        :comments,-> { order 'created_at asc' },as: :commentable,dependent: :destroy
end
