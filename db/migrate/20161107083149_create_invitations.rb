class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :inviter, index: true
      t.references :target, polymorphic: true, index: true
      t.datetime :expited_at
      t.integer :teacher_percent
      t.integer :status, default: 0
      t.text :remark
      t.string :type

      t.timestamps null: false
    end
  end
end
