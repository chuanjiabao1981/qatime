class AddIsTopToFaqs < ActiveRecord::Migration
  def change
    add_column :faqs,:is_top,:integer,:default  => 0
  end
end
