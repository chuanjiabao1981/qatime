class AddStateToCourse < ActiveRecord::Migration
  def change
    add_column :courses,:state,:string,default: "unpublished"
  end
end
