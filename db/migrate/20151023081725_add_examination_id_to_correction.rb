class AddExaminationIdToCorrection < ActiveRecord::Migration
  def change
    add_column :corrections,:examination_id,:integer
  end
end
