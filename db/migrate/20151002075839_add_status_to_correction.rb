class AddStatusToCorrection < ActiveRecord::Migration
  def change
    add_column :corrections,:status,:boolean,default:false
  end
end
