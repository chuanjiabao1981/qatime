class Teacher < User
  include Registable

  serialize :grade_range, Array
  default_scope {where(role: 'teacher')}

  has_many :curriculums,dependent: :destroy
  has_many :courses,dependent: :destroy

  # has_many :deposits

  has_many :answers,:dependent => :destroy
  has_many :learning_plan_assignments, :dependent => :destroy
  has_many :learning_plans,:through => :learning_plan_assignments

  has_many :customized_course_assignments, :dependent => :destroy
  has_many :customized_courses, :through => :customized_course_assignments
  has_many :customized_tutorials,:dependent => :destroy
  has_many :question_assignments,:dependent => :destroy
  has_many :questions, :through => :question_assignments

  has_many :syllabuses, class_name: CourseLibrary::Syllabus,foreign_key: :author_id

  has_many :live_studio_courses, class_name: LiveStudio::Course
  has_many :live_studio_lessons, class_name: LiveStudio::Lesson, through: :live_studio_courses, source: :lessons

  has_many :invitations, foreign_key: :user_id, class_name: LiveStudio::CourseInvitation

  # has_many :corrections
  # has_many :replies

  belongs_to :workstation
  belongs_to :school
  attr_reader :teacher_columns_required
  attr_accessor :school_name

  # 第二步注册，教师更新验证
  validates_presence_of :subject, :category, :city_id, if: :teacher_columns_required?, on: :update

  # 资料编辑验证
  validates_presence_of :subject, :category, :city_id, :school_id, :desc, :teaching_years, if: :context_edit_profile?

  validates :desc, length: { in: 6..400 }, if: :context_edit_profile?

  # 学校不能为空
  validates :school, presence: true, on: :update

  scope :by_category, ->(c) { where(category: c) if c}
  scope :by_subject, ->(s) { where(subject: s) if s}
  scope :by_school, ->(s) { where(school_id: s) if s}
  scope :by_vip_class, ->(vip_class) {includes(:school).order("schools.name desc").by_subject(vip_class.subject).by_category(vip_class.category) }

  TEACHING_YEARS_HASH = {
    within_three_years: 3,
    within_ten_years: 10,
    within_twenty_years: 20,
    more_than_twenty_years: 21
  }

  enumerize :teaching_years, in: TEACHING_YEARS_HASH,
                      i18n_scope: "enums.teacher.teaching_years",
                      default: :within_three_years,
                      scope: true,
                      predicates: { prefix: true }

  def initialize(attributes = {})
    super(attributes)
    self.role = "teacher"
  end

  def find_or_create_curriculums
    s = []
    TeachingProgram.where(:category => self.category, :subject => self.subject).order(:created_at).each do |teaching_program|
      s.append(Curriculum.find_or_create_by(teacher_id: self.id, teaching_program_id: teaching_program.id))
    end
    s
  end

  def keep_account
    [CustomizedTutorial, HomeworkCorrection,ExerciseCorrection].each do |s|
      s.by_teacher_id(self.id).valid_tally_unit.each do |object|
        object.keep_account(self.id)
      end
    end

    [TutorialIssueReply, CourseIssueReply].each do |s|
      s.by_author_id(self.id).valid_tally_unit.each do |object|
        object.keep_account(self.id)
      end
    end
  end

  def grade_range_text
    _grade_range = grade_range
    _grade_range.delete("")
    _grade_range.join(" ")
  end

  # 老师必填字段
  def teacher_columns_required?
    @teacher_columns_required == true || teacher_or_student_columns_required?
  end

  # 强制设置老师必填字段
  def teacher_columns_required!
    teacher_or_student_columns_required!
    @teacher_columns_required = true
    self
  end

  private

  # 老师的地区信息从学校获取
  before_validation :clone_city
  def clone_city
    return if city_id || school.blank?
    self.city = school.city
    self.province = city.province if city
  end
end
