namespace :nginx do


  %w[start stop restart].each do |command|
    task command do
      on roles(:web) do |host|
        puts "#{host} #{command} nginx"
        execute "sudo service nginx #{command}"
      end
    end
  end
  desc "just for test"
  task :test do
    on roles(:web) do |host|
      execute  'sudo add-apt-repository ppa:nginx/stable' do |ch, stream, data|
        puts "data"
      end
    end
  end
end