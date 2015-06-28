class CustomizedTutorial < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  include ActiveModel::Dirty

  include VideoConvert

  belongs_to :teacher
  belongs_to :customized_course

  has_one    :video,:dependent => :destroy,as: :videoable
end
