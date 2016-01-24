class CustomizedTutorial < ActiveRecord::Base

  include QaToken
  include QaCommon
  include Tally
  include QaCustomizedCourseActionRecord

  include QaTemplate::Material



  validates_presence_of :title,:customized_course,:teacher,:last_operator
  scope                 :by_teacher, lambda {|t| where(teacher_id: t) if t}


  belongs_to :teacher
  belongs_to :last_operator,class_name: User
  belongs_to :customized_course,:counter_cache => true

  belongs_to :template, class_name: CourseLibrary::Course

  has_one    :video,:dependent => :destroy,as: :videoable
  has_one    :fee, as: :feeable

  has_many   :solutions,as: :solutionable,:dependent =>  :destroy

  has_many   :tutorial_issues,:dependent => :destroy do
    def build(attributes={})
      attributes[:customized_course_id] = proxy_association.owner.customized_course_id
      super attributes
    end
  end



  has_many   :exercises,:dependent => :destroy do
    def build(attributes={})
      attributes[:customized_course_id] = proxy_association.owner.customized_course_id
      super attributes

    end
  end

  has_one :video_quoter,as: :file_quoter
  has_one :template_video,through: :video_quoter,source: :video



  self.per_page = 10

  def initialize(attributes = {})
    super(attributes)
    self.generate_token if  self.token == nil or self.token.empty?
  end

  def author
    self.teacher
  end
  def author_id
    self.teacher_id
  end

  def operator_id
    self.teacher_id
  end


  def name
    self.title
  end


  def self.create_from_template(customized_course_id,template)
    #如果customized_course中已经了有一个customized_tutorial使用此template， 则只同步这个customized_tutorial
    already_tutorials =     CustomizedTutorial.where(customized_course_id: customized_course_id,template_id: template.id)

    if not already_tutorials.blank?
      already_tutorials.each do |t|
        t.sync_with_template
      end
      return
    end

    # 没有的话,创建
    a = template.customized_tutorials.build(customized_course_id: customized_course_id,
                                        title: template.title,
                                        content: template.description,
                                        teacher_id: template.directory.syllabus.author.id,
                                        last_operator_id: template.author_id
    )
    a.template_video        = template.video
    a.template_picture_ids  = template.picture_ids
    a.template_file_ids     = template.qa_file_ids

    a.save
    a.create_exercises_from_template
    a
  end


  def create_exercises_from_template
    return if self.template.nil?
    already_published_homework    = []
    self.exercises.each do |e|
      if e.template
        already_published_homework << e.template.id
        e.sync_with_template
      end
    end
    self.template.homeworks.each do |homework|
      if not already_published_homework.include?(homework.id)
        Exercise.create_from_template(self,homework)
      end
    end
  end

  def sync_with_template
    return if self.template.nil?
    self.title                 = self.template.title
    self.content               = self.template.description
    self.template_video        = self.template.video
    self.template_picture_ids  = self.template.picture_ids
    self.template_file_ids     = self.template.qa_file_ids
    self.save
    self.sync_exercises_with_template
    self
  end

  def sync_exercises_with_template
    return if self.template.nil?
    self.exercises.each do |exercise|
      exercise.sync_with_template
      if not exercise.template_id.nil? and not self.template.has_the_homework?(exercise.template_id)
        #TODO:: 如果模板中已经没有这个作业了，do something
      end
    end
    #把新加的作业也同步过去
    self.create_exercises_from_template
    self
  end

  def is_any_component_charged?
    return true if self.is_charged?
    self.exercises.each do |e|
      return true if e.is_any_component_charged?
    end
    return false
  end
  def is_same_with_template?
    diff = []
    template = self.template
    if template.nil?
      diff << "not exsits"
      return false
    end
    if self.title != template.title
      diff << "title"
    end
    if self.content != template.description
      diff << "description"
    end
    if self.template_video  != template.video
      diff << "video"
    end


    if not same_array?(self.template_picture_ids,template.picture_ids)
      diff << "pictures"
    end


    if not same_array?(self.template_file_ids,template.qa_file_ids)
      diff << "files"
    end

    self.exercises.each do |exercise|
      if not exercise.is_same_with_template?
        diff << "exercise #{exercise.id}"
      end
    end
    if diff.blank?
      return true
    end
    return false
  end


  private
  def same_array?(a,b)
    a = a || []
    b = b || []
    a.uniq.sort  == b.uniq.sort
  end

end
