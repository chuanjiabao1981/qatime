class CustomizedCourse < ActiveRecord::Base
  belongs_to :student
  has_many :customized_course_assignments,:dependent => :destroy
  has_many :teachers,:through => :customized_course_assignments
  has_many :customized_tutorials,:dependent => :destroy
  has_many :tutorial_issues

  has_many :fees

  has_many :course_issues

  has_many :homeworks,:dependent => :destroy

  validates_presence_of :subject,:category,:student
  validates_numericality_of :price, only_integer: true
  validate :validate_price,:on => :create

  attr_accessor :s_category,:s_school,:s_subject
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

  private
  # This validation is used to check whether the input price is greater than the min price
  def validate_price
    if self.category == "高中"
      price_valid(APP_CONSTANT["customized_course_senior_high_common_prices"])
    elsif self.category == "初中"
      price_valid(APP_CONSTANT["customized_course_junior_high_common_prices"])
    else
      price_valid(APP_CONSTANT["customized_course_junior_common_prices"])
    end
  end

  def price_valid(price_dict)
    min_price = price_dict[self.customized_course_type]
    if self.price < min_price
      self.errors.add(:price,"价格低于该课程最低价:每小时" + min_price.to_s)
    else
      self.teacher_price = min_price * APP_CONSTANT["teacher_earning_percent"]
    end
  end
end