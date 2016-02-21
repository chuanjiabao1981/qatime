module CourseLibrary
  class HomeworkPublication < ActiveRecord::Base
    belongs_to :homework
    belongs_to :course_publication

    has_one :exercise,dependent: :destroy


    validates_uniqueness_of :homework_id ,scope: :course_publication_id


    before_destroy :with_payment? ,prepend: true


    def with_payment?

      if ExerciseService::Fee::AnyComponentCharged.new(self.exercise).judge?
        errors.add(:base,"已经计费无法删除")
        return false
      else
        return true
      end
    end
  end
end
