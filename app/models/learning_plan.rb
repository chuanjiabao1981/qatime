class LearningPlan < ActiveRecord::Base
  belongs_to :student
  belongs_to :vip_class

  validates :duration_type, inclusion: { in: APP_CONSTANT["learning_plan"]["duration_types"].keys,
                                message: "%{value} is not a valid type" }

  validates_presence_of :student,:vip_class,:price,:begin_at,:end_at,:teachers,:duration_type

  has_many :teachers ,through: :learning_plan_assignments
  has_many :learning_plan_assignments


  def expired?
    return false if self.begin_at <= Time.zone.now and Time.zone.now <= self.end_at
    true
  end
  def initialize(attributes = {})
    super(attributes)
    self.vip_class_id = 1 if not self.vip_class_id
    self.begin_at   = Time.zone.now.to_date
    if self.duration_type
      self.end_at     = self.begin_at + eval(APP_CONSTANT["learning_plan"]["duration_types"][self.duration_type]["time"])
      self.price      = APP_CONSTANT["learning_plan"]["duration_types"][self.duration_type]["price"]
    end
  end

end
