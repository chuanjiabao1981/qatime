class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.string :name
      t.text :desc
      t.string :token
      t.references :user, index: true

      t.timestamps
    end
  end
end
