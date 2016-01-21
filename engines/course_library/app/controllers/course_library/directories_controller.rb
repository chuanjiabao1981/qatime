require_dependency "course_library/application_controller"

module CourseLibrary
  class DirectoriesController < ApplicationController

    def new
      @syllabus = Syllabus.find(params[:syllabus_id])
      @directory = @syllabus.directories.build
      @directory.parent_id = params[:p]
    end

    def show
      @syllabus = Syllabus.find(params[:syllabus_id])
      @directory = Directory.find(params[:id])
      @children = Directory.where(parent_id: params[:id])
      @jstree = get_dir_tree(@directory.id)
    end

    def create
      @syllabus = Syllabus.find(params[:syllabus_id])
      @directory = @syllabus.directories.create(params[:directory].permit!)
      if @directory.save
        redirect_to syllabus_directory_path(@syllabus,@directory.parent_id)
      else
        render 'new'
      end
    end

    def edit
      @syllabus = Syllabus.find(params[:syllabus_id])
      @directory = Directory.find(params[:id])
    end

    def update
      @syllabus = Syllabus.find(params[:syllabus_id])
      @directory = Directory.find(params[:id])
      if @directory.update_attributes(params[:directory].permit!)
        redirect_to syllabus_directory_path(@syllabus,@directory.parent_id)
      else
        render 'edit'
      end
    end

    def destroy
      @directory = Directory.find(params[:id])
      @directory.destroy
      redirect_to syllabus_directory_path(@directory.syllabus,@directory.parent_id)
    end

    private def get_dir_tree ( selected_node )
      syllabus = Syllabus.find(params[:syllabus_id])
      data = Array.new
      syllabus.directories.each do |d|
        status = d.id == selected_node
        node = { "id" => d.syllabus.id.to_s + "_" + d.id.to_s,
                 "parent" => (d.parent==nil)?"#":d.parent.syllabus.id.to_s + "_" + d.parent_id.to_s,
                 "text" => d.title,
                 "state" => { "selected" => status },
                 "a_attr" => { "href" => syllabus_directory_path(syllabus,d) }
        }
        data.push(node)
      end
      jstree = { "core" => { "data" => data, "multiple" => false } }
    end

  end
end
