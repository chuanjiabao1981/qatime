class GroupType < ActiveRecord::Base
  has_many :group_catalogues

  def self.get_grade_group_types(all_group_types,subject,grade)
    a = []
    all_group_types.each do |group_type|
      if group_type.grade == grade and group_type.subject == subject
        a << group_type
      end
    end
    a
  end
end
