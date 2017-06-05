# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path


# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w(*.js)
Rails.application.config.assets.precompile += %w(web_home.css front.css front_live.css v1/front_live.css manager_home.css wap.css v1_application.css)
Rails.application.config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

Rails.application.config.assets.precompile << Proc.new { |path|
  if path =~ /\.(eot|svg|ttf|woff)\z/
    true
  end
}
