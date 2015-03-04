class AddSubjectAndCategoryToTeacher < ActiveRecord::Migration
  def change
    add_column :users, :subject,  :string
    add_column :users, :category, :string
  end
end
