class AddColumnsToTeachers < ActiveRecord::Migration
  def change
    add_column :users, :highest_education, :string
    add_column :users, :teaching_years, :integer
    add_column :users, :grade_range, :string
  end
end
