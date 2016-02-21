module CourseLibrary
  module DirectoriesHelper
    def get_dir_tree ( syllabus, selected_directory )
      data = Array.new
      if(selected_directory.id.nil?)
        selected_directory = selected_directory.parent
      end
      syllabus.directories.each do |d|
        status = d.id == selected_directory.id
        node = { "id" => d.syllabus.id.to_s + "_" + d.id.to_s,
                 "parent" => (d.parent==nil)?"#":d.parent.syllabus.id.to_s + "_" + d.parent_id.to_s,
                 "text" => d.title,
                 "state" => { "selected" => status, "opened" => status },
                 "a_attr" => { "href" => syllabus_directory_path(syllabus,d) }
        }
        data.push(node)
      end
      dir_tree_json = { "core" => { "data" => data, "multiple" => false } }.to_json
    end
  end
end
