module LiveStudio
  class Engine < ::Rails::Engine
    isolate_namespace LiveStudio

    config.to_prepare do
      Dir.glob(Rails.root + "app/jobs/**/*.rb").each do |c|
        require_dependency(c)
      end
    end
  end
end
