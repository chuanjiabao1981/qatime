class Software < ApplicationRecord
  extend Enumerize
  validates_presence_of :title, :sub_title, :platform, :version, :role, :desc, :description, :cdn_url, :logo, :category

  mount_uploader :logo, SoftwareLogoUploader
  has_one :qr_code, as: :qr_codeable

  PLATFORM_HASH = {
    windows: 1,
    android: 2,
    ios: 3
  }

  enum status: %w(init published expired)
  enum role: { teacher: 'teacher', student: 'student' }
  enum category: %w(teacher_live student_client)

  enumerize :platform, in: PLATFORM_HASH,
            i18n_scope: "enums.software.platform",
            scope: true,
            predicates: { prefix: true }

  def published!
    self.published_at = Time.now
    super
  end

  def status_text
    I18n.t("enums.software.status.#{status}")
  end

  def category_text
    I18n.t("enums.software.category.#{category}")
  end

  def assign_qr_code
    relative_path = QrCode.generate_tmp(download_links)
    tmp_path = Rails.root.join(relative_path)
    File.open(tmp_path) do |file|
      self.create_qr_code(code: file)
    end
    File.delete(tmp_path)
  end

  private

  before_update :generate_download_links
  def generate_download_links
    self.download_links = "#{$host_name}/softwares/#{id}/download" if download_links.blank?
    assign_qr_code
  end

  class << self
    # 获取publish状态下地所有应用,以version倒序排序,以title分组
    def auto_sort(user)
      Software::PLATFORM_HASH.values.map do |plat|
        sql = "select max(version) over (PARTITION BY category order by version desc),* from softwares where softwares.platform=#{plat} and status=#{Software.statuses[:published]}"
        sql += " and softwares.role = '#{user.role}'" if user.student? || user.teacher?
        Software.find_by_sql(sql)
      end.flatten.uniq.compact
    end

    def i18n_categories
      Software.categories.map{|k,_| [I18n.t("enums.software.category.#{k}"), k]}
    end
  end
end
