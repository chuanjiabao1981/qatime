class AddCurriculumReferencyToCourses < ActiveRecord::Migration
  def change
    add_column :courses,        :curriculum_id,     :integer
    add_column :courses,        :chapter,           :string
    add_column :curriculums,    :courses_count,     :integer,   :default  => 0
    add_column :curriculums,    :lessons_count,     :integer,   :default  => 0
  end
end
