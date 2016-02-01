class AddTemplateIdtoCorrection < ActiveRecord::Migration
  def change
    add_column :corrections,:template_id,:integer
  end
end
