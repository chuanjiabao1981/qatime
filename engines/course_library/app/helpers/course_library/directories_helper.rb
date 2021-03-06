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
                 "a_attr" => { "href" => syllabus_directory_path(syllabus,d),
                               "id" =>  d.get_full_path.map{|d| "#{d.title}"}.join(" > ")}
        }
        data.push(node)
      end
      dir_tree_json = { "core" => { "data" => data, "multiple" => false } }.to_json
    end

    def get_forbidden_move_dir_ids (directory)
      ([directory] + get_all_children(directory,nil)).map{|r| "#{r.id}"}.join("_")
    end

    def get_all_children ( directory, children )
      if children.nil?
        children = Array.new
      end
      directory.children.each do |d|
        children.push(d)
        get_all_children(d,children)
      end
      return children
    end
  end
end
