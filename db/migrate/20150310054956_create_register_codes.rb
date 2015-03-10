class CreateRegisterCodes < ActiveRecord::Migration
  def change
    create_table :register_codes do |t|
      t.string    :value, null:false
      t.string    :state, default: "available"
      t.integer   :teacher_id
      t.timestamps null: false
    end
  end
end
