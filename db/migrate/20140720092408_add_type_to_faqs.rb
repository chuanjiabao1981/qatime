class AddTypeToFaqs < ActiveRecord::Migration
  def change
    add_column      :faqs,:type,:string
  end
end
