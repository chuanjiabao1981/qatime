module CourseLibrary
  class Directory < ActiveRecord::Base
    validates_presence_of :title
    belongs_to :syllabus, class_name: CourseLibrary::Syllabus
    belongs_to :parent, class_name: CourseLibrary::Directory
    has_many  :children, class_name: CourseLibrary::Directory
    has_many   :courses

    def get_full_path
      full_path = Array.new
      cur = self
      while(!cur.nil?) do
        if(!cur.id.nil?)
          full_path.insert(0,cur)
        end
        cur = cur.parent
      end
      full_path
    end

  end
end
