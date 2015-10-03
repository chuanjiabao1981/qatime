class AddCorrectionInfoToSolution < ActiveRecord::Migration
  def change
    add_column :solutions,:first_handle_created_at,:timestamp
    add_column :solutions,:last_handle_created_at,:timestamp
    add_column :solutions,:first_handle_author_id,:integer
    add_column :solutions,:last_handle_author_id,:integer

    Solution.all.each do |s|
      s.update_handle_infos(s.corrections)
      puts "#{s.corrections_count}----#{s.first_handle_created_at}-----#{s.last_handle_created_at}"
    end
  end
end
