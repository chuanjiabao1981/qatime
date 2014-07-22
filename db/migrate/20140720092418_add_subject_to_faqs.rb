class AddSubjectToFaqs < ActiveRecord::Migration
  def change
    add_column      :faqs,:subject,:string
  end
end
