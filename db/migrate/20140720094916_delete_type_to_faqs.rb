class DeleteTypeToFaqs < ActiveRecord::Migration
  def change
    remove_column   :faqs,:type,:string
  end
end