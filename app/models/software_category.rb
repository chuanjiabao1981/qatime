class SoftwareCategory < ActiveRecord::Base
  has_many :softwares

  enum platform: {
    windows: 1,
    android: 2,
    ios: 3
  }
end
