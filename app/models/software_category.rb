class SoftwareCategory < ActiveRecord::Base
  extend Enumerize

  enum status: { unavailable: 0, available: 1 }
  enum platform: { windows: 1, android: 2, ios: 3 }
  enum role: { teacher: 'teacher', student: 'student' }
  enum category: { teacher_live: 'teacher_live', student_client: 'student_client' }
  enumerize :role, in: { teacher: 'teacher', student: 'student' }
  enumerize :category, in: { teacher_live: 'teacher_live', student_client: 'student_client' }
  enumerize :platform, in: { windows: 1, android: 2, ios: 3 }

  validates_presence_of :title, :platform, :role, :logo, :category

  has_many :softwares, -> { where(status: 1).order('version_value desc') }
  mount_uploader :logo, SoftwareLogoUploader

  scope :available, -> { where(status: 1).order('position') }

  def app?
    platform.android?
  end
end
