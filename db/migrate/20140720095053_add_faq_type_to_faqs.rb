class AddFaqTypeToFaqs < ActiveRecord::Migration
  def change
    add_column      :faqs,:faq_type,:string
  end
end
