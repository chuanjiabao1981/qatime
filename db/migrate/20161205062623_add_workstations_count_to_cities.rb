class AddWorkstationsCountToCities < ActiveRecord::Migration
  def change
    add_column :cities, :workstations_count, :integer, default: 0
    
    Workstation.all.each do |w|
      City.reset_counters(w.city_id, :workstations) if w.city
    end

  end
end
