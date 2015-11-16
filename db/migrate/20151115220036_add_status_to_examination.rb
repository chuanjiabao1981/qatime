class AddStatusToExamination < ActiveRecord::Migration
  def change
    add_column :examinations,:state,:string,default: :new
  end
end
