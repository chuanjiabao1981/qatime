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
    self.logo = software_category.logo
    self.title = software_category.title
    self.sub_title = software_category.sub_title
    self.desc = software_category.desc
    self.download_description = software_category.download_description
    self.category = software_category.category
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
