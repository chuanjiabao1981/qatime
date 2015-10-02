class AddStatusToCustomizedTutorial < ActiveRecord::Migration
  def change
    add_column :customized_tutorials,:status,:boolean,default:false

  end
end
