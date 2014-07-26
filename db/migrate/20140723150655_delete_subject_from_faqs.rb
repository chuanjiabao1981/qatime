class DeleteSubjectFromFaqs < ActiveRecord::Migration
  def change
    remove_column   :faqs,:subject,:string
  end
end
