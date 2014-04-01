class AddSectionIdToTopicsAndTutorials < ActiveRecord::Migration
  def up
    add_column :topics    ,:section_id,:integer
    add_column :tutorials ,:section_id,:integer
    Topic.all.each do|topic|
      topic.section_id = topic.node.section.id
      topic.save
    end
    Tutorial.all.each do |tutorial|
      tutorial.section_id = tutorial.node.section.id
      tutorial.save
    end
  end

  def down
    remove_column :topics,:section_id
    remove_column :tutorials,:section_id
  end
end
