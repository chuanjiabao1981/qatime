class CustomizedCourse < ActiveRecord::Base
  belongs_to :student
  has_many :customized_course_assignments,:dependent => :destroy
  has_many :teachers,:through => :customized_course_assignments
  has_many :customized_tutorials,:dependent => :destroy
  has_many :tutorial_issues
  belongs_to :workstation
  belongs_to :creator, :class_name => "User"

  has_many :fees

  has_many :course_issues

  has_many :homeworks,:dependent => :destroy

  validates_presence_of :subject,:category,:student, :platform_price, :teacher_price, :creator_id, :workstation_id

  before_validation :set_prices

  attr_accessor :s_category,:s_school,:s_subject, :sale_price
  enum customized_course_type: { heighten: 0, spurt: 1, competition: 2}

  # has_many timeout_to_solve_homework, lambda { where(solutions_count: 0)},class_name: "Homework"
  def timeout_to_solve_homeworks
    self.homeworks.where("created_at <?",3.day.ago).where('solutions_count = 0')
  end
  def name
    "#{CustomizedCourse.model_name.human}-#{self.created_at.strftime("%Y-%m-%d")}"
  end

  def self.customized_course_type_attributes_for_select
    customized_course_types.map do |customized_course_type, _|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.customized_course_types.#{customized_course_type}"), customized_course_type]
    end
  end

  # This function is used to set prices for customized_course
  private

  def set_prices
    if self.new_record?
      __set_prices
    else
      if self.subject_changed? or self.customized_course_type_changed?
        __set_prices
      end
    end
  end

  def __set_prices
    teacher_price, platform_price = CustomizedCourse.get_customized_course_prices(self.category, self.customized_course_type)
    self.teacher_price = teacher_price
    self.platform_price = platform_price
  end

  def self.get_customized_course_prices(category, customized_course_type)
    if category == "高中"
      price_dict = APP_CONSTANT["customized_course_senior_high_common_prices"]
    elsif category == "初中"
      price_dict = APP_CONSTANT["customized_course_junior_high_common_prices"]
    else
      price_dict = APP_CONSTANT["customized_course_junior_common_prices"]
    end

    Rails.logger.info price_dict.as_json.to_s

    Rails.logger.info customized_course_type.as_json.to_s

    teacher_price = price_dict[customized_course_type]["teacher_price"]
    platform_price = price_dict[customized_course_type]["platform_price"]

    [teacher_price, platform_price]
  end
end