class AddToken < ActiveRecord::Migration
  def change
    add_column :qa_faqs,:token,:string
  end
end
