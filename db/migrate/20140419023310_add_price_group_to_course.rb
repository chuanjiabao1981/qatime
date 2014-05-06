class AddPriceGroupToCourse < ActiveRecord::Migration
  def change
    add_column      :courses , :price,:float,:default => 0.0
    add_column      :courses , :group_id,:integer
    add_column      :courses , :teacher_id,:integer
    remove_column   :courses , :node_id,:integer
    remove_column   :courses , :section_id,:integer
    remove_column   :courses , :author_id,:integer
  end
end
