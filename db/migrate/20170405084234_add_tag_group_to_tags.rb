class AddTagGroupToTags < ActiveRecord::Migration
  def change
    add_reference :tags, :tag_group, index: true
  end
end
