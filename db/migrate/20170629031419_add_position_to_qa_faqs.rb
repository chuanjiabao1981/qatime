class AddPositionToQaFaqs < ActiveRecord::Migration
  def change
    add_column :qa_faqs, :position, :integer, default: 0
    add_column :qa_faqs, :show_type, :integer, default: 0
  end
end
