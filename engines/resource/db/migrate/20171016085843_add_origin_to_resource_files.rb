class AddOriginToResourceFiles < ActiveRecord::Migration
  def change
    add_reference :resource_files, :origin, polymorphic: true
  end
end
