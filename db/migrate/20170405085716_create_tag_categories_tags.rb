class CreateTagCategoriesTags < ActiveRecord::Migration
  def change
    create_table :tag_categories_tags, id: false do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :tag_category, index: true
    end
  end
end
