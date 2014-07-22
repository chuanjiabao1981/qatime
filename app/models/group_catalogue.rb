class GroupCatalogue < ActiveRecord::Base

  def get_courses(courses)
    a = []
    courses.each do |course|
      if course.group_catalogue_id == self.id
        a << course
      end
    end
    a
  end
end
