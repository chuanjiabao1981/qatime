class Software < ActiveRecord::Base
  extend Enumerize
  validates_presence_of :title, :sub_title, :platform, :version, :role, :desc, :description, :cdn_url, :logo, :category

  mount_uploader :logo, SoftwareLogoUploader
  has_one :qr_code, as: :qr_codeable

  belongs_to :software_category

  validates :software_category, presence: true

  PLATFORM_HASH = {
    windows: 1,
    android: 2,
    ios: 3
  }

  enum status: %w(init published expired offline)
  enum role: { teacher: 'teacher', student: 'student' }
  enum category: %w(teacher_live student_client)

  enumerize :platform, in: PLATFORM_HASH,
            i18n_scope: "enums.software.platform",
            scope: true,
            predicates: { prefix: true }

  def self.latest_student_windows_client
    published.where(software_category_id: 4).order(version: :desc).first
  end

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
    relative_path = QrCode.generate_tmp(cdn_url)
    tmp_path = Rails.root.join(relative_path)
    File.open(tmp_path) do |file|
      self.create_qr_code(code: file)
    end
    File.delete(tmp_path)
  end

  def copy_attr_from_category!
    copy_attr_from_category
    save
  end

  before_validation :cal_version_value, if: :version_changed?
  def cal_version_value
    if version
      value1, value2, value3 = version.split('.').reverse
      self.version_value = value1.to_i + value2.to_i * 100 + value3.to_i * 100 * 100
    else
      self.version_value = 0
    end
    self
  end

  def self.teacher_apps
    android_app = Software.where(platform: 2, role: 'teacher', status: 1).order('version_value').last
    ios_app = Software.where(platform: 3, role: 'teacher', status: 1).order('version_value').last
    [android_app, ios_app]
  end

  def self.student_apps
    android_app = where(platform: 2, role: 'student', status: 1).order('version_value').last
    ios_app = where(platform: 3, role: 'student', status: 1).order('version_value').last
    [android_app, ios_app]
  end

  private

  before_update :generate_download_links
  def generate_download_links
    self.download_links = "#{$host_name}/softwares/#{id}/download" if download_links.blank?
    assign_qr_code if qr_code.nil? || cdn_url_changed?
  end

  before_validation :copy_attr_from_category, on: :create
  def copy_attr_from_category
    return unless software_category
    self.role = software_category.role
    self.platform = software_category.platform
    self.remote_logo_url = software_category.logo_url if software_category.logo.present?
    self.title = software_category.title
    self.sub_title = software_category.sub_title
    self.desc = software_category.desc
    self.download_description = software_category.download_description
    self.category = software_category.category
    self.position = software_category.position
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
