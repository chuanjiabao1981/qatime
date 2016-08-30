class AppInfo < ActiveRecord::Base

  validates_presence_of :category, :version, :level, :download_url, :description

  mount_uploader :qr_code, QrCodeUploader

  enum status: %w(init running expired)

  enum category: %w(student_android teacher_pc)

  def running!
    self.running_at = Time.now
    self.assign_qr_code
    super
  end

  def status_text
    I18n.t("enums.app_info.status.#{status}")
  end

  def enforce_text
    enforce ? '是' : '否'
  end

  def category_text
    I18n.t("enums.app_info.category.#{category}")
  end

  class << self
    def i18n_categories
      categories.map{|k,_| [I18n.t("enums.app_info.category.#{k}"),k]}
    end
  end

  def assign_qr_code
    relative_path = Payment::Qr_Code.generate_tmp(self.download_url)
    tmp_path = Rails.root.join(relative_path)
    File.open(tmp_path) do |file|
      self.qr_code = file
    end
    File.delete(tmp_path)
  end

end
