class Software < ActiveRecord::Base
  extend Enumerize
  validates_presence_of :title, :sub_title, :platform, :version, :role, :desc, :description, :download_links

  mount_uploader :logo, SoftwareLogoUploader
  mount_uploader :qr_code, SoftwareQrCodeUploader

  PLATFORM_HASH = {
    windows: 1,
    android: 2,
    ios: 3
  }

  enum status: %w(init running expired)
  enum role: { teacher: 'teacher', student: 'student' }

  enumerize :platform, in: PLATFORM_HASH,
            i18n_scope: "enums.software.platform",
            scope: true,
            predicates: { prefix: true }

  def running!
    self.running_at = Time.now
    self.assign_qr_code
    super
  end

  def status_text
    I18n.t("enums.software.status.#{status}")
  end

  def assign_qr_code
    relative_path = Payment::Qr_Code.generate_tmp(self.download_links)
    tmp_path = Rails.root.join(relative_path)
    File.open(tmp_path) do |file|
      self.qr_code = file
    end
    File.delete(tmp_path)
  end

  class << self
    # 获取running状态下地所有应用,以version倒序排序,以title分组
    def auto_sort(user)
      Software::PLATFORM_HASH.values.map do |plat|
        sql = "select max(version) over (PARTITION BY title order by version desc),* from softwares where softwares.platform=#{plat} and status=#{Software.statuses[:running]}"
        sql += " and softwares.role = '#{user.role}'" if user.student? || user.teacher?
        Software.find_by_sql(sql)
      end.flatten.uniq.compact
    end

    # 获取running状态下地所有应用,以version倒序排序,以title分组
    def find_and_sort_by(title,version,platform)
      sql = "select max(version) over (PARTITION BY title order by version desc),* from softwares where softwares.platform=#{platform} and status=#{Software.statuses[:running]}"
      Software.find_by_sql(sql)
    end
  end
end
