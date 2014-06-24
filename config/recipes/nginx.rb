namespace :nginx do


  %w[start stop restart].each do |command|
    task command do
      on roles(:web) do |host|
        puts "#{host} #{command} nginx"
        execute "sudo service nginx #{command}"
      end
    end
  end
end