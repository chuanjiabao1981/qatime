class CreateReviewRecords < ActiveRecord::Migration
  def change
    create_table :review_records do |t|
      t.integer     :lesson_id
      t.integer     :manager_id
      t.string      :complete_state #审核的最终状态（published还是rejected）
      t.string      :start_state    #从哪个状态提交的审核
      t.text        :reason
      t.timestamps  :compeleted_at
      t.timestamps null: false
    end
  end
end
