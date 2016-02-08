class CustomizedTutorial
  module CustomizedTutorial::Utils extend ActiveSupport::Concern

  def template_directory_path_str

      if not template.nil? and not template.directory.nil?
        prefix = nil
        template.directory.get_full_path.each do |d|
          prefix = "#{prefix}"+"[#{d.title}] "
        end
        return "#{prefix}"
      end
    end

    def title_with_template_directory_path_str
      "#{template_directory_path_str} #{title}"
    end
  end


end