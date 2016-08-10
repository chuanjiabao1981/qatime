namespace :nginx do


  %w[start stop restart].each do |command|
    task command do
      on roles(:web) do |host|
        puts "#{host} #{command} nginx"
        execute "sudo service nginx #{command}"
      end
    end
  end

  task :replace_config do
    on roles(:web) do |host|
      puts "#{host} replace nginx config"
      execute "sudo cp /etc/nginx/sites-enabled/qatime.nginx.conf /etc/nginx/sites-enabled/qatime-#{Date.today}.nginx.conf"
      execute "sudo cp ~/nginx.conf /etc/nginx/sites-enabled/qatime.nginx.conf"
      execute "sudo service nginx restart"
    end
  end
end