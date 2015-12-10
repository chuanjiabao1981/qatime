class AddStateToSolution < ActiveRecord::Migration
  def change
    add_column :solutions,:state,:string,default: :new
  end
end
