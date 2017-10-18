# This migration comes from resource (originally 20171016085843)
class AddOriginToResourceFiles < ActiveRecord::Migration
  def change
    add_reference :resource_files, :origin, polymorphic: true
  end
end
