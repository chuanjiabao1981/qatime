class AddStatusToReply < ActiveRecord::Migration
  def change
    add_column :replies,:status,:boolean,default:false
  end
end
