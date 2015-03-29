class CreateLearningPlans < ActiveRecord::Migration
  def change
    create_table :learning_plans do |t|
      t.string        :duration_type
      t.string        :state
      t.integer       :student_id
      t.integer       :vip_class_id
      t.float         :price
      t.datetime      :begin_at
      t.datetime      :end_at
      t.timestamps    null: false
    end
  end
end
