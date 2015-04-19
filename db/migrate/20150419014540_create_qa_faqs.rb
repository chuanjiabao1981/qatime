class CreateQaFaqs < ActiveRecord::Migration
  def change
    create_table :qa_faqs do |t|
      t.string    :title
      t.text      :content
      t.integer   :qa_faq_type,default:0
      t.timestamps null: false
    end
  end
end
