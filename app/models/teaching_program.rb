class TeachingProgram < ActiveRecord::Base

  validates_presence_of :name, :category, :grade, :content, :subject
  validates_uniqueness_of :name ,scope: [:category, :subject]


  def self.get_names(all_teaching_program,subject,grade)
    a = []

    all_group_types.each do |group_type|
      if group_type.grade == grade and group_type.subject == subject
        a << group_type
      end
    end
    a
  end
end
